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
#import "SIPELogger.h"

// Handle for C API
SIPEService * refSIPEService;

#pragma mark  -
#pragma mark SIPEService Framework Implementations
#pragma mark  -
//===============================================================================
// SIPEService Framework Implementations
//===============================================================================
@implementation SIPEService

@synthesize version = _version;
@synthesize mainBundle = _mainBundle;

static SIPELogger * logger;

-(instancetype) init
{
    logger = [SIPELogger getLogger];
    [logger debugMessage:@"Initialising SIPEService"];

    if((self = [super init]))
    {
        _mainBundle = [[NSBundle mainBundle] infoDictionary];
        _version = [self.mainBundle objectForKey:@"CFBundleShortVersionString"];
    }

    // Initialise reference for c
    refSIPEService = self;
    return self;
}


- (void) dealloc
{

}

-(void) login
{
    // TODO: "" may be better
    // Initialise the sipe core
    [logger debugMessage:@"Initialising sipe_core"];
    sipe_core_init(LOCALEDIR);
}

-(void) logout
{
    // Shudown the sipe core
    [logger debugMessage:@"Destroying sipe_core"];
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


