//
//  SIPEConnection.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "sipe-core.h"
#import "SIPEConnection.h"
#import "SIPETransport.h"
#import "SIPEService.h"
#import "SIPEAccount.h"
#import "SIPELogger.h"
#import "SIPEHelpers.h"

@implementation SIPEConnection

-(instancetype) initWithAccount: (SIPEAccount *) account
{
    NSAssert(nil != account, @"Account must be set before login attempted");
    sipe_log_trace(@"Initialising SIPEConection");

    if (self = [super init]) {
        _account  = account;
        _transport = [SIPETransport new];
        _disconnecting = NO;
        _connected = NO;
    }
    
    return self;
}

-(void) start
{
    sipe_log_debug(@"Starting connection...");
    sipe_core_transport_sip_connect([self.account sipePublic],
                                    [self.account transport],
                                    [self.account authentication],
                                    NSSTRING_TO_GCHAR([self.account server]),
                                    NSSTRING_TO_GCHAR([self.account port]));
}

-(void) stop
{
    // TODO - make safe if not fully connected
    sipe_log_debug(@"Stopping connection");
    [self setDisconnecting:YES];

    // TODO - anything extra for shutdown (Offline)?

    [self setConnected:NO];
    [self setDisconnecting:NO];
}

// TODO: Event for when connection change;

@end

#pragma mark  -
#pragma mark SIPE C Backend CONNECTION Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend CONNECTION Functions
//===============================================================================
// TODO: Review against Purple
void sipe_backend_connection_completed(struct sipe_core_public *sipe_public)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
    SIPEService * imService = SIPE_PUBLIC_TO_IMSERVICE;
    assert(imService);

    [imService.connection setDisconnecting:NO];
    [imService.connection setConnected:YES];
}

void sipe_backend_connection_error(struct sipe_core_public *sipe_public,
                                   sipe_connection_error error,
                                   const gchar *msg)
{
    sipe_log_error(@"sipe_backend connection error: (%d) %s",error,msg);
    SIPEService * imService = SIPE_PUBLIC_TO_IMSERVICE;
    assert(imService);

    [imService.connection stop];
}

gboolean sipe_backend_connection_is_disconnecting(struct sipe_core_public *sipe_public)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
    SIPEService * imService = SIPE_PUBLIC_TO_IMSERVICE;
    assert(imService);

    return [imService.connection isDisconnecting];
}

gboolean sipe_backend_connection_is_valid(struct sipe_core_public *sipe_public)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
    SIPEService * imService = SIPE_PUBLIC_TO_IMSERVICE;
    assert(imService);

    return [imService.connection isConnected];
}

