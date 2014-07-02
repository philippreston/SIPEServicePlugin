//
//  SIPETransport.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#include <gio/gio.h>
#import "sipe-backend.h"
#import "sipe-core.h"
#import "SIPETransport.h"
#import "SIPEService.h"
#import "SIPEConnection.h"
#import "SIPELogger.h"
#import "SIPEException.h"
#import "SIPEHelpers.h"

@interface SIPETransport () {
    transport_connected_cb * _connectedCb;
	transport_input_cb * _inputCb;
	transport_error_cb * _errorCb;
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
-(void) disconnectWithStatus:(SIPETransportStatus) status;

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

@end

@implementation SIPETransport

static SIPELogger * logger;

-(instancetype) init
{
    logger = [SIPELogger getLogger];
    [logger debugMessage:@"Initialising Transport"];

    if(self = [super init]) {
        _connectedCb = NULL;
        _inputCb = NULL;
        _errorCb = NULL;
        _data = [NSData new];
        _status = SIPETransportStatusNotOpen;

        // FIXME - can this be moved to ARC
        _connection = (struct sipe_transport_connection *) malloc(sizeof(struct sipe_transport_connection));
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
    [self setStatus:SIPETransportStatusOpening];

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

    [logger info:@"SIPETransport connecting to %@:%i", [self server], [self port]];

    // Connect
    switch ([self type]) {
        case SIPE_TRANSPORT_TLS:
        {
            [logger infoMessage:@"SIPETransport connecting using SSL/TLS"];
            [self connectSSL];
            break;
        }
        case SIPE_TRANSPORT_TCP:
        {
            [logger infoMessage:@"SIPETransport connecting using TCP"];
            [self connectTCP];
            break;
        }
        case SIPE_TRANSPORT_AUTO:
        default:
        {
            // Should not get here
            NSString * msg = [NSString stringWithFormat:@"Connection type (%d) - should not happen",[self type]];
            [logger fatal:msg];
            [self errorWithMsg:msg];
            [self setStatus:SIPETransportStatusError];
            sipe_backend_transport_disconnect([self connection]);
            break;
        }

    }
}

-(void) disconnect
{
    [logger info:@"SIPETransport disconnecting from %@:%i", [self server], [self port]];
    [self disconnectWithStatus:SIPETransportStatusClosed];
}

-(void) disconnectWithStatus:(SIPETransportStatus) status
{

    // Close the input stream
    [self.readStream close];
    [self.readStream removeFromRunLoop: [NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    // Close the output stream
    [self.writeStream close];
    [self.writeStream removeFromRunLoop: [NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    [self setStatus:status];

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

    // Run in loop in background
    [self.readStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
    [self.writeStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];

    // Do we need TLS/SSL
    if (secure) {
        [logger debugMessage:@"SIPETransport adding TLS Security level to connection"];
        [self.writeStream setProperty:NSStreamSocketSecurityLevelTLSv1 forKey:NSStreamSocketSecurityLevelKey];
        [self.readStream setProperty:NSStreamSocketSecurityLevelTLSv1 forKey:NSStreamSocketSecurityLevelKey];
    }

    // Open the streams
    if([self.readStream streamStatus] == NSStreamStatusNotOpen)
        [self.readStream open];
    if([self.writeStream streamStatus] == NSStreamStatusNotOpen)
        [self.writeStream open];

    // Testing
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];

}


- (void)stream:(NSStream *)aStream
   handleEvent:(NSStreamEvent)eventCode;
{
    [logger debug:@"Stream Event Occured"];
    switch (eventCode) {

        case NSStreamEventOpenCompleted:
        {
            [logger debug:@"%@ Stream is open", (aStream == _readStream) ? @"Input":@"Output"];
            [self setStatus:SIPETransportStatusOpen];
            [self connected];
            // TODO - client port to be stored
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            [logger debug:@"%@ Stream has bytes available", (aStream == _readStream) ? @"Input":@"Output"];
            [self setStatus:SIPETransportStatusReading];
            //TODO: Implement
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            [logger debug:@"%@ Stream has space available", (aStream == _readStream) ? @"Input":@"Output"];
            [self setStatus:SIPETransportStatusWriting];
            //TODO: Implement
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
            [logger errorMessage:errMsg];
            [self errorWithMsg:errMsg];

            // Clean up streams
            [self disconnectWithStatus:SIPETransportStatusError];

            break;
        }
        case NSStreamEventEndEncountered:
        {
            [logger debug:@"%@ Stream has end event", (aStream == _readStream) ? @"Input":@"Output"];

            // Clean up streams
            [self disconnectWithStatus:SIPETransportStatusAtEnd];

            break;
        }
        case NSStreamEventNone:
        default:
        {
            [logger warn:@"Encountered unsupported event type (%@)", eventCode];
            break;
        }
    }

}

-(void) connected
{
    NSAssert(_connection,@"sipe_transport_connection is NULL");
    NSAssert(_connectedCb,@"SIPE Transport connect callback not set");
    _connectedCb([self connection]);
}

-(void) input
{
    NSAssert(_connection,@"sipe_transport_connection is NULL");
    NSAssert(_inputCb,@"SIPE Transport input callback not set");
    _inputCb([self connection]);
}

-(void) errorWithMsg: (NSString *) msg;
{
    NSAssert(_connection,@"sipe_transport_connection is NULL");
    NSAssert(_errorCb,@"SIPE Transport error callback not set");
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
    [logger debugMessage:@"SIPE backend transport connect"];
    SIPEService * imService = SIPE_PUBLIC_TO_IMSERVICE;
    assert(imService);

    [imService.connection.transport connect:sipe_public WithSetup:setup];

    return [imService.connection.transport connection];
}

void sipe_backend_transport_disconnect(struct sipe_transport_connection *conn)
{
    [logger debugMessage:@"SIPE backend transport disconnect"];
    SIPEService * imService = SIPE_TRANSPORT_TO_IMSERVICE;
    assert(imService);

    [imService.connection.transport disconnect];
}

void sipe_backend_transport_message(struct sipe_transport_connection *conn,
                                    const gchar *buffer)
{
    // TODO: Implement
    [logger debugMessage:@"SIPE backend transport message"];
}

void sipe_backend_transport_flush(struct sipe_transport_connection *conn)
{
    [logger debugMessage:@"SIPE backend transport flush"];
}


#pragma mark  -
#pragma mark SIPE C Backend NETWORK Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend NETWORK Functions
//===============================================================================
const gchar *sipe_backend_network_ip_address(struct sipe_core_public *sipe_public)
{
    // TODO: Implement
    return NULL;
}

struct sipe_backend_listendata * sipe_backend_network_listen_range(unsigned short port_min,
                                                                   unsigned short port_max,
                                                                   sipe_listen_start_cb listen_cb,
                                                                   sipe_client_connected_cb connect_cb,
                                                                   gpointer data)
{
    // TODO: Implement
    return NULL;
}
void sipe_backend_network_listen_cancel(struct sipe_backend_listendata *ldata)
{
    // TODO: Implement
}

gboolean sipe_backend_fd_is_valid(struct sipe_backend_fd *fd)
{
    // TODO: Implement
    return NO;
}

void sipe_backend_fd_free(struct sipe_backend_fd *fd)
{
    // TODO: Implement
}

// TODO: Network Callbacks

#pragma mark  -
#pragma mark SIPE C Backend SETTINGS Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend SETTINGS Functions
//===============================================================================
const gchar *sipe_backend_setting(struct sipe_core_public *sipe_public,
                                  sipe_setting type)
{
    return NULL;
}
