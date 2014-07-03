//
//  SIPEGroupChat.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPELogger.h"
#import "SIPEGroupChat.h"

@implementation SIPEGroupChat

@end

#pragma mark  -
#pragma mark SIPE C Backend GROUPCHAT Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend GROUPCHAT Functions
//===============================================================================
void sipe_backend_groupchat_room_add(struct sipe_core_public *sipe_public,
                                     const gchar *uri,
                                     const gchar *name,
                                     const gchar *description,
                                     guint users,
                                     guint32 flags)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_groupchat_room_terminate(struct sipe_core_public *sipe_public)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

