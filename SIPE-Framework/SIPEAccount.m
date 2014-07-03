//
//  SIPEAccount.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 26/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "sipe-core.h"
#import "SIPEHelpers.h"
#import "SIPELogger.h"
#import "SIPEAccount.h"
#import "SIPEService.h"
#import "SIPEException.h"

@interface SIPEAccount ()
@property (readwrite) BOOL publishCalendar;
@end

@implementation SIPEAccount
@synthesize sipePublic = sipe_public;


-(instancetype) init
{
    sipe_log_trace(@"Initialising SIPEAccount");
    if( self = [super init])
    {
        [self setUserAgent:nil];
        [self setUsername:nil];
        [self setPassword:nil];
        [self setAccount:nil];
        [self setEmail:nil];
        [self setEmailUrl:nil];
        [self setDomain:nil];
        [self setAuthentication:NTLM];
        [self setSingleSignOn:NO];
        [self setPublishCalendar:NO];

        [self setServer:nil];
        [self setPort:nil];
        [self setTransport:AUTO];
    }
    return self;
}


-(void) open
{
    sipe_log_debug(@"Attempting to allocate account");

    // TODO: do we need password
    //    _requiresPassword =
    //    sipe_core_transport_sip_requires_password([self.account authentication],
    //                                             [self.account singleSignOn]);

    // Validate data prior to sipe core
    [self validate];

    // TODO: Single Sign on

    // TODO: Domain name split

    const gchar * errMessage;
    sipe_public = sipe_core_allocate(NSSTRING_TO_GCHAR([self username]),
                                     [self singleSignOn],
                                     NSSTRING_TO_GCHAR([self domain]),
                                     NSSTRING_TO_GCHAR([self account]),
                                     NSSTRING_TO_GCHAR([self password]),
                                     NSSTRING_TO_GCHAR([self email]),
                                     NSSTRING_TO_GCHAR([self emailUrl]),
                                     &errMessage);

    // Cannot progress if this fails
    if (!sipe_public) {
        NSString * msg = [NSString stringWithFormat:@"Failed to allocate Account: %s", errMessage];
        sipe_log_error(msg);
        NSException * ex = [SIPEException exceptionWithName: @"SIPEException"
                                                     reason: msg
                                                   userInfo: nil];
        @throw ex;
    }

    // FIXME: publish calendar option - no supported - cannot change
    SIPE_CORE_FLAG_UNSET(DONT_PUBLISH);
    if(NO == [self publishCalendar])
        SIPE_CORE_FLAG_SET(DONT_PUBLISH);

}

-(void) close
{
    if(sipe_public)
    {
        sipe_core_deallocate(sipe_public);
    }
}

-(void) setServer:(NSString *) server
         WithPort:(NSString*) port
{
    [self setServer:server];
    [self setPort:port];
}

-(void) validate
{
    ASSERT_NOT_NIL(_username, @"SIPEAccount - username cannot be nil");
    ASSERT_NOT_NIL(_password, @"SIPEAccount - password cannot be nil");
    ASSERT_NOT_NIL(_account, @"SIPEAccount - account cannot be nil");
}
@end

#pragma mark  -
#pragma mark SIPE C Backend SETTINGS Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend SETTINGS Functions
//===============================================================================
const gchar *sipe_backend_setting(struct sipe_core_public *sipe_public,
                                  sipe_setting type)
{
    // TODO: IMplement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    SIPEService * imService = SIPE_PUBLIC_TO_IMSERVICE;
    assert(imService);

    const gchar * tmp;
    switch (type) {
        case SIPE_SETTING_EMAIL_URL:
            tmp = NSSTRING_TO_GCHAR([imService.account emailUrl]);
            break;
        case SIPE_SETTING_USER_AGENT:
            tmp = NSSTRING_TO_GCHAR([imService.account userAgent]);
            break;
        case SIPE_SETTING_LAST:
        case SIPE_SETTING_EMAIL_LOGIN:
        case SIPE_SETTING_EMAIL_PASSWORD:
        case SIPE_SETTING_GROUPCHAT_USER:
        default:
            sipe_log_warn(@"sipe_setting (%d) type not supporter or found",type);
            break;
    }
    return tmp;
}
