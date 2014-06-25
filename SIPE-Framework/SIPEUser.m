//
//  SIPEUser.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPEUser.h"

@implementation SIPEUser

@end

#pragma mark  -
#pragma mark SIPE C Backend USER Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend USER Functions
//===============================================================================
void sipe_backend_user_feedback_typing(struct sipe_core_public *sipe_public,
                                       const gchar *from)
{
    // TODO: Implement
}

void sipe_backend_user_feedback_typing_stop(struct sipe_core_public *sipe_public,
                                            const gchar *from)
{
    // TODO: Implement
}

void sipe_backend_user_ask(struct sipe_core_public *sipe_public,
                           const gchar *message,
                           const gchar *accept_label,
                           const gchar *decline_label,
                           gpointer key)
{
    // TODO: Implement
}

void sipe_backend_user_close_ask(gpointer key)
{
    // TODO: Implement
}
