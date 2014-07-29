//
//  SIPETransport.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <netinet/in.h>
#import <arpa/inet.h>
#import <glib.h>
#import <gio/gio.h>
#import <string.h>
#import "sipe-backend.h"
#import "sipe-core.h"
#import "SIPETransport.h"
#import "SIPEService.h"
#import "SIPEConnection.h"
#import "SIPELogger.h"
#import "SIPEException.h"
#import "SIPEHelpers.h"

#define READ_MAX_SIZE           1024
#define TRANSPORT_QUEUE_NAME    "transport_queue"

@interface SIPETransport () {
    transport_connected_cb * _connectedCb;
	transport_input_cb * _inputCb;
	transport_error_cb * _errorCb;
    dispatch_queue_t _transportQueue;
}

//===============================================================================
// Private Methods
//===============================================================================
-(void) connected;
-(void) input;
-(void) errorWithMsg: (NSString *) msg;
-(void) connectWithSecure:(BOOL) secure;
-(void) connectSSL;
-(void) connectTCP;
-(void) disconnectWithState:(SIPETransportState) status;

//===============================================================================
// Private Properties
//===============================================================================
@property (readwrite) UInt32 type;
@property (readwrite) NSData * data;
@property (readwrite) NSString * server;
@property (readwrite) UInt32 port;
@property (readwrite) gpointer * pointer;
@property (readwrite) NSInputStream * readStream;
@property (readwrite) NSOutputStream * writeStream;
@property (readwrite) NSRunLoop * runLoop;
@property (readwrite) NSString * localIPAddress;
@property (readonly) NSMutableArray * writeQueue;

@end

@implementation SIPETransport


-(instancetype) init
{
    sipe_log_debug(@"SIPETransport Initialising");

    if(self = [super init]) {
        _connectedCb = NULL;
        _inputCb = NULL;
        _errorCb = NULL;
        _data = [NSData new];
        _state = SIPETransportStateUnknown;
        _transportQueue = dispatch_queue_create(TRANSPORT_QUEUE_NAME, nil);
        _runLoop = nil;
        _writeQueue = [NSMutableArray new];
        _connection = (struct sipe_transport_connection *) calloc(1,sizeof(struct sipe_transport_connection));
    }

    return self;
}

-(void) dealloc
{
    if (_connection) {
        free(_connection);
    }
}

-(void) connect:(struct sipe_core_public*) sipe_public
      WithSetup:(const sipe_connect_setup*) setup;
{
    [self setState:SIPETransportStateInitialising];

    // Store the connection details
    [self setType: setup->type];
    [self setServer: GCHAR_TO_NSSTRING(setup->server_name)];
    [self setPort: setup->server_port];

    // Store the callback function pointers
    _connectedCb = setup->connected;
    _inputCb = setup->input;
    _errorCb = setup->error;

    // Need certain parts from setup for the core transport
    _connection->type = setup->type;
    _connection->user_data = setup->user_data;

    sipe_log_info(@"Connecting to %@:%i", [self server], [self port]);

    // Connect
    switch ([self type]) {
        case SIPE_TRANSPORT_TLS:
        {
            sipe_log_info(@"Connecting using SSL/TLS");
            [self connectSSL];
            break;
        }
        case SIPE_TRANSPORT_TCP:
        {
            sipe_log_info(@"Connecting using TCP");
            [self connectTCP];
            break;
        }
        case SIPE_TRANSPORT_AUTO:
        default:
        {
            // Should not get here
            NSString * msg = [NSString stringWithFormat:@"Connection type (%d) - should not happen",[self type]];
            sipe_log_fatal(msg);
            [self errorWithMsg:msg];
            [self setState:SIPETransportStateError];
            sipe_backend_transport_disconnect([self connection]);
            break;
        }

    }
}

-(void) disconnect
{
    sipe_log_info(@"SIPETransport disconnecting from %@:%i", [self server], [self port]);
    [self disconnectWithState:SIPETransportStateClosed];
}

-(void) disconnectWithState:(SIPETransportState) status
{

    // Close the input stream
    [self.readStream close];
    [self.readStream removeFromRunLoop: [self runLoop] forMode:NSDefaultRunLoopMode];
    _readStream = nil;

    // Close the output stream
    [self.writeStream close];
    [self.writeStream removeFromRunLoop: [self runLoop] forMode:NSDefaultRunLoopMode];
    _writeStream = nil;

    CFRunLoopRef cfRunLoop = [self.runLoop getCFRunLoop];
    CFRunLoopStop(cfRunLoop);

    [self setState:status];

}

-(void) connectSSL
{
    [self connectWithSecure:YES];
}

-(void) connectTCP
{
    [self connectWithSecure:NO];
}

-(void) connectWithSecure:(BOOL) secure
{

    // Create the connection to the service
    CFReadStreamRef rStream;
    CFWriteStreamRef wStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)([self server]), [self port], &rStream, &wStream);

    // Store the streams as NSStreams
    [self setReadStream: (__bridge_transfer NSInputStream *)(rStream)];
    [self setWriteStream:(__bridge_transfer NSOutputStream *)(wStream)];

    // Set Delegate
    [self.readStream setDelegate: self];
    [self.writeStream setDelegate: self];

    // Do we need TLS/SSL
    if (secure) {
        sipe_log_debug(@"SIPETransport adding TLS Security level to connection");
        [self.writeStream setProperty:NSStreamSocketSecurityLevelTLSv1 forKey:NSStreamSocketSecurityLevelKey];
        [self.readStream setProperty:NSStreamSocketSecurityLevelTLSv1 forKey:NSStreamSocketSecurityLevelKey];
    }

    // Run in transport thread
    dispatch_async(_transportQueue, ^(void) {

        // Store the run loop
        [self setRunLoop:[NSRunLoop currentRunLoop]];

        // Set the streams to be scheduled in the loop
        [self.writeStream scheduleInRunLoop:[self runLoop]
                                    forMode:NSDefaultRunLoopMode];
        [self.readStream scheduleInRunLoop:[self runLoop]
                                   forMode:NSDefaultRunLoopMode];

        // Open the streams
        if([self.writeStream streamStatus] == NSStreamStatusNotOpen)
            [self.writeStream open];
        if([self.readStream streamStatus] == NSStreamStatusNotOpen)
            [self.readStream open];

        // TODO: May need a break condidition (e.g. run for few secs - check then run again)
        // Run the loop
        [self.runLoop run];
        sipe_log_trace(@"Loop ending...");

    });

}


-(void) sendMessage:(NSData *) data
{
    sipe_log_debug(@"Sending data");

    // Check the stream is open
    if ([self.writeStream streamStatus] != NSStreamStatusOpen) {
        sipe_log_error(@"Output stream not open");
        return;
    }

    // Send the data
    if([self.writeStream hasSpaceAvailable]) {
        NSInteger written = [self.writeStream write: [data bytes]
                                          maxLength: [data length]];

        // post remaining data to queue to be written (asynchronous)
        if (written < [data length]) {
            sipe_log_debug(@"Not all data could be sent to stream - queueing");
            NSData * stillToWrite = [data subdataWithRange:NSMakeRange(written, [data length])];
            [self.writeQueue addObject:stillToWrite];
        }
    }
    else {
        sipe_log_debug(@"No space on the writeStream");
        [self.writeQueue addObject: data];
    }

}


- (void)stream:(NSStream *)aStream
   handleEvent:(NSStreamEvent)eventCode;
{
    sipe_log_debug(@"Stream Event Occured");
    switch (eventCode) {

        case NSStreamEventOpenCompleted:
        {
            sipe_log_debug(@"%@ Stream is open", (aStream == _readStream) ? @"Input":@"Output");

            if(aStream == [self readStream]) {

                CFReadStreamRef tmpReadStream = (__bridge CFReadStreamRef)(aStream);
                CFDataRef socketData = CFReadStreamCopyProperty(tmpReadStream, kCFStreamPropertySocketNativeHandle);
                if(nil == socketData) {
                    sipe_log_warn(@"Could not retrieve socket data for input stream");
                    return;
                }

                // Get the socket handle
                CFSocketNativeHandle socketHandle;
                CFDataGetBytes(socketData,CFRangeMake(0, sizeof(CFSocketNativeHandle)),
                               (UInt8 *)&socketHandle);
                if(0 == socketHandle) {
                    sipe_log_warn(@"Could not retrieve socket handle for input stream");
                    return;
                }

                // Get the socket
                CFSocketRef socket = CFSocketCreateWithNative (NULL,socketHandle,kCFSocketNoCallBack,NULL,NULL);
                if(nil == socket) {
                    sipe_log_warn(@"Could not retrieve socket for input stream");
                    return;
                }

                // Get the socket addr info
                CFDataRef sockAddrData = CFSocketCopyAddress(socket);
                struct sockaddr_in * sockaddr = (struct sockaddr_in *) CFDataGetBytePtr(sockAddrData);
                if(NULL == socket) {
                    sipe_log_warn(@"Could not retrieve socket address for input stream");
                    return;
                }

                // Store the IP and Port
                self.connection->client_port = sockaddr->sin_port;
                char ipAddress[INET_ADDRSTRLEN];
                inet_ntop(AF_INET, &(sockaddr->sin_addr), ipAddress, INET_ADDRSTRLEN);
                [self setLocalIPAddress:GCHAR_TO_NSSTRING((const char *)ipAddress)];

            }

            // Tell the backend
            if([self.readStream streamStatus] == NSStreamStatusOpen &&
               [self.writeStream streamStatus] == NSStreamStatusOpen) {

                sipe_log_debug(@"Both streams are open - tell backend");
                [self setState:SIPETransportStateOpen];
                [self connected];
            }

            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            sipe_log_debug(@"%@ Stream has bytes available", (aStream == _readStream) ? @"Input":@"Output");
            if(aStream == [self readStream]) {

                sipe_log_debug(@"Current buffer length is: %d", _connection->buffer_length);
                NSInteger length = 0;

                do {

                    // Adjust the buffer size
                    if (_connection->buffer_length < _connection->buffer_used + READ_MAX_SIZE) {
                        _connection->buffer_length += READ_MAX_SIZE;
                        _connection->buffer = (gchar *)realloc(_connection->buffer, _connection->buffer_length);
                        sipe_log_debug(@"Resized buffer length to: %d", _connection->buffer_length);
                    }

                    // Create container for this read
                    length = [self.readStream read:(uint8_t *)(_connection->buffer + _connection->buffer_used) maxLength:READ_MAX_SIZE];

                    // Not worked
                    if (length < 0) {
                        NSString * errString = [NSString stringWithFormat:@"Error (%ld) occured reading input stream", (long)length];
                        sipe_log_error(errString);
                        [self errorWithMsg:errString];
                        return;
                    }

                    _connection->buffer_used += length;
                }
                while ([self.readStream hasBytesAvailable]);

                // Add string terminator and send
                _connection->buffer[_connection->buffer_used] = '\0';
                [self input];

            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            sipe_log_debug(@"%@ Stream has space available", (aStream == _readStream) ? @"Input":@"Output");

            sipe_log_debug(@"Queued data objects to write: %d", [self.writeQueue count]);
            if (aStream == [self writeStream]) {

                // While there is something to write and space available - write
                while ([self.writeQueue count] > 0 && [self.writeStream hasSpaceAvailable]) {

                    // Get the next data object
                    NSData * data = [self.writeQueue firstObject];

                    // Write data object
                    NSInteger written = [self.writeStream write: [data bytes]
                                                      maxLength: [data length]];

                    // post remaining data to queue to be written and wait for next availability
                    if (written < [data length]) {
                        sipe_log_debug(@"Not all data could be sent to stream in event - updating slot 0 in queue");
                        NSData * stillToWrite = [data subdataWithRange:NSMakeRange(written, [data length])];

                        // Overwrite data at front of queue as needs to be written next
                        [self.writeQueue setObject:stillToWrite atIndexedSubscript:0];
                    }
                    else {
                        sipe_log_debug(@"Done with top object - ditch");

                        // Remove the first object
                        [self.writeQueue removeObjectAtIndex:0];
                    }

                }

            }
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            //  Something has gone wrong
            NSError * err = [aStream streamError];
            NSString * errMsg = [NSString stringWithFormat:@"%@ Stream encountered error (%li): %@",
                                 (aStream == _readStream) ? @"Input":@"Output",
                                 [err code],
                                 [err localizedDescription]];
            sipe_log_error(errMsg);
            [self errorWithMsg:errMsg];

            // Clean up streams
            [self disconnectWithState:SIPETransportStateError];

            break;
        }
        case NSStreamEventEndEncountered:
        {
            sipe_log_debug(@"%@ Stream has end event", (aStream == _readStream) ? @"Input":@"Output");

            // Clean up streams
            [self disconnectWithState:SIPETransportStateClosed];

            break;
        }
        case NSStreamEventNone:
        default:
        {
            sipe_log_warn(@"Encountered unsupported event type (%@)", eventCode);
            break;
        }
    }

}

-(void) connected
{
    NSAssert(_connection,@"sipe_transport_connection is NULL");
    NSAssert(_connectedCb,@"SIPE Transport connect callback not set");
    sipe_log_trace(@"SIPETransport calling connect for sipe_core");
    _connectedCb([self connection]);
}

-(void) input
{
    NSAssert(_connection,@"sipe_transport_connection is NULL");
    NSAssert(_inputCb,@"SIPE Transport input callback not set");
    sipe_log_trace(@"SIPETransport calling input for sipe_core");
    _inputCb([self connection]);
}

-(void) errorWithMsg: (NSString *) msg;
{
    NSAssert(_connection,@"sipe_transport_connection is NULL");
    NSAssert(_errorCb,@"SIPE Transport error callback not set");
    sipe_log_trace(@"SIPETransport calling error for sipe_core");
    _errorCb([self connection] ,NSSTRING_TO_GCHAR(msg));
}

@end

#pragma mark  -
#pragma mark SIPE C Backend TRANSPORT Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend TRANSPORTs Functions
//===============================================================================
struct sipe_transport_connection *sipe_backend_transport_connect(struct sipe_core_public *sipe_public,
                                                                 const sipe_connect_setup *setup)
{
    sipe_log_trace(@"%s",__FUNCTION__);
    SIPEService * imService = SIPE_PUBLIC_TO_IMSERVICE;
    assert(imService);

    [imService.connection.transport connect:sipe_public WithSetup:setup];

    return [imService.connection.transport connection];
}

void sipe_backend_transport_disconnect(struct sipe_transport_connection *conn)
{
    sipe_log_trace(@"%s",__FUNCTION__);
    SIPEService * imService = SIPE_TRANSPORT_TO_IMSERVICE;
    assert(imService);

    [imService.connection.transport disconnect];
}

void sipe_backend_transport_message(struct sipe_transport_connection *conn,
                                    const gchar *buffer)
{
    sipe_log_trace(@"%s",__FUNCTION__);
    SIPEService * imService = SIPE_TRANSPORT_TO_IMSERVICE;
    assert(imService);

    // Get buffer size and NSData
    NSUInteger size = strlen(buffer);
    NSData * data = [NSData dataWithBytes: (void *) buffer
                                   length: size];

    [imService.connection.transport sendMessage: data];

}

void sipe_backend_transport_flush(struct sipe_transport_connection *conn)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
}


#pragma mark  -
#pragma mark SIPE C Backend NETWORK Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend NETWORK Functions
//===============================================================================
const gchar *sipe_backend_network_ip_address(struct sipe_core_public *sipe_public)
{
    sipe_log_trace(@"%s",__FUNCTION__);
    SIPEService * imService = SIPE_PUBLIC_TO_IMSERVICE;
    assert(imService);

    NSString * ipAddr = [imService.connection.transport localIPAddress];
    if(nil == ipAddr) {
        sipe_log_error(@"Could not retrieve the IP Address");
        return NULL;
    }

    sipe_log_debug(@"Local IP address is %@", ipAddr);

    return NSSTRING_TO_GCHAR(ipAddr);
}

struct sipe_backend_listendata * sipe_backend_network_listen_range(unsigned short port_min,
                                                                   unsigned short port_max,
                                                                   sipe_listen_start_cb listen_cb,
                                                                   sipe_client_connected_cb connect_cb,
                                                                   gpointer data)
{
    // TODO: Move to Stub
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}
void sipe_backend_network_listen_cancel(struct sipe_backend_listendata *ldata)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
    // TODO: Move to Stub
}

gboolean sipe_backend_fd_is_valid(struct sipe_backend_fd *fd)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
    // TODO: Move to Stub
    return NO;
}

void sipe_backend_fd_free(struct sipe_backend_fd *fd)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
    // TODO: Move to Stub
}

// TODO: Network Callbacks


