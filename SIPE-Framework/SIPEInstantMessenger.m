//
//  SIPEInstantMessenger.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPEInstantMessenger.h"
#import "SIPELogger.h"

@implementation SIPEInstantMessenger

@end

#pragma mark  -
#pragma mark SIPE C Backend IM Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend IM Functions
//===============================================================================
void sipe_backend_im_message(struct sipe_core_public *sipe_public,
                             const gchar *from,
                             const gchar *html)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_im_topic(struct sipe_core_public *sipe_public,
                           const gchar *with,
                           const gchar *topic)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}