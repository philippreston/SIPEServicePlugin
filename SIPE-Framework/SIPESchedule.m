//
//  SIPESchedule.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPELogger.h"
#import "SIPESchedule.h"

@implementation SIPESchedule

@end


#pragma mark  -
#pragma mark SIPE C Backend SCHEDULE Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend SCHEDULE Functions
//===============================================================================
gpointer sipe_backend_schedule_seconds(struct sipe_core_public *sipe_public,
                                       guint timeout,
                                       gpointer data)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

gpointer sipe_backend_schedule_mseconds(struct sipe_core_public *sipe_public,
                                        guint timeout,
                                        gpointer data)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

void sipe_backend_schedule_cancel(struct sipe_core_public *sipe_public,
                                  gpointer data)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

