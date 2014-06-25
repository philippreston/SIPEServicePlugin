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

//===============================================================================
// MACROS
//===============================================================================
// TODO: Make this dynamic
#define FRAMEWORK_VERSION @"0.0.1"

// Handle for C API
SIPEService * refSIPEService;

#pragma mark  -
#pragma mark SIPEService Framework Implementations
#pragma mark  -
//===============================================================================
// SIPEService Framework Implementations
//===============================================================================
@implementation SIPEService

@synthesize enableDebug = _enableDebug;
@synthesize version = _version;


-(instancetype) init
{
    if((self = [super init]))
    {
        _version = FRAMEWORK_VERSION;

        // Initialise reference for c
        refSIPEService = self;
    }
    return self;
}


- (void) dealloc
{

}

-(void) login
{
    // TODO: "" may be better
    // Initialise the sipe core
    sipe_core_init(LOCALEDIR);
}

-(void) logout
{
    // Shudown the sipe core
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


#pragma mark  -
#pragma mark SIPE C Backend DEBUG Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend DEBUG Functions
//===============================================================================
gboolean sipe_backend_debug_enabled(void)
{
    return [refSIPEService enableDebug];
}

void sipe_backend_debug_literal(sipe_debug_level level,
                                const gchar *msg)
{
    // TODO: Implement
}

void sipe_backend_debug(sipe_debug_level level,
                        const gchar *format,
                        ...)
{
    // TODO: Implement
}




