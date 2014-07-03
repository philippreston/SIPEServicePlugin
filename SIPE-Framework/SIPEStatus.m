//
//  SIPEStatus.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPELogger.h"
#import "SIPEStatus.h"

@implementation SIPEStatus

@end

#pragma mark  -
#pragma mark SIPE C Backend STATUS Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend STATUS Functions
//===============================================================================
guint sipe_backend_status(struct sipe_core_public *sipe_public)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return 0;
}

gboolean sipe_backend_status_changed(struct sipe_core_public *sipe_public,
                                     guint activity,
                                     const gchar *message)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NO;
}

void sipe_backend_status_and_note(struct sipe_core_public *sipe_public,
                                  guint activity,
                                  const gchar *message)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}
