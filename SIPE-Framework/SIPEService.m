//
//  SIPEService.m
//  SIPEService
//
//  Created by Philip Preston on 20/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//


//===============================================================================
// Imports
//===============================================================================
#import <glib.h>
#import "sipe-backend.h"
#import "sipe-core.h"
#import "SIPEService.h"
#import "SIPEAccount.h"
#import "SIPELogger.h"
#import "SIPEConnection.h"
#import "SIPEException.h"

// Handle for C API
SIPEService * refSIPEService;

#pragma mark  -
#pragma mark SIPEService Framework Implementations
#pragma mark  -
//===============================================================================
// SIPEService Framework Implementations
//===============================================================================


@implementation SIPEService

static SIPELogger * logger;

-(instancetype) init
{
    logger = [SIPELogger getLogger];
    [logger debugMessage:@"Initialising SIPEService"];

    if((self = [super init]))
    {
        // TODO: Fix Versioning
        _mainBundle = [[NSBundle mainBundle] infoDictionary];
        _version = [self.mainBundle objectForKey:@"CFBundleShortVersionString"];
        _connection = nil;
        _account = nil;
    }

    [logger info:@"Running SIPE Framework version: %@", [self version]];
    
    // Initialise reference for C
    refSIPEService = self;
    return self;
}

-(void) loginWithAccount: (SIPEAccount *) acc
{
    [self setAccount:acc];
    [self login];
}

-(void) login
{
    // Initialise the sipe core
    [logger debugMessage:@"Initialising sipe_core"];
    sipe_core_init(LOCALEDIR);

    NSAssert(nil != _account, @"Account must be set before login attempted");

    // Open and store the service to private
    [self.account open];
    [self.account sipePublic]->backend_private = (__bridge void*) self;

    // Connect to transport
    _connection = [[SIPEConnection alloc] initWithAccount: [self account]];
    [self.connection start];


    // TODO: Rejoin chats

    // TODO: Set connection name and flags

    // TODO: 

    // Connect

}

-(void) logout
{
    // Shudown the sipe core
    [logger debugMessage:@"Logging out sipe_core"];
    [self.connection stop];
    [self.account close];

    // TODO - close down DNS

    // TODO - close down Transport


    sipe_core_destroy();
}

@end

#pragma mark  -
#pragma mark SIPE C Backend MISC Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend MISC Functions
//===============================================================================
gchar * sipe_backend_version(void)
{
    return (gchar *)[refSIPEService.version
                     cStringUsingEncoding: NSUTF8StringEncoding];
}


