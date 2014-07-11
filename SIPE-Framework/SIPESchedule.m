//
//  SIPESchedule.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "sipe-core.h"
#import "SIPELogger.h"
#import "SIPESchedule.h"

@interface SIPESchedule () {
    NSTimer * _timer;
}

-(void) timerCallback: (NSTimer * ) timer;
@end

@implementation SIPESchedule

+(instancetype) getScheduler
{
    static SIPESchedule * scheduler;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        scheduler = [SIPESchedule new];
    });

    return scheduler;
}

-(instancetype) init
{
    sipe_log_trace(@"Initialising SIPESchedule");
    if (self = [super init]) {
        _timer = nil;
    }

    return self;
}


-(void) sendData: (gpointer) data
       afterTime: (NSTimeInterval) time
{
    sipe_log_debug(@"Running timer for %f", time);
    NSValue * userData = [NSValue valueWithPointer: data];
    _timer = [NSTimer scheduledTimerWithTimeInterval: time
                                              target: self
                                            selector: @selector(timerCallback:)
                                            userInfo: userData
                                             repeats: NO];

    // Add to run loop
    [[NSRunLoop currentRunLoop] addTimer: _timer
                                 forMode: NSDefaultRunLoopMode];
}

-(void) cancel
{
    sipe_log_debug(@"Cancelling timer");
    [_timer invalidate];
    _timer = nil;
}


-(void) timerCallback: (NSTimer * ) timer
{
    sipe_log_debug(@"Timer has been called");
    gpointer data = [timer.userInfo pointerValue];
    NSAssert(data, @"Data cannot be null");
    sipe_core_schedule_execute(data);
}

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
    sipe_log_trace(@"%s",__FUNCTION__);
    SIPESchedule * scheduler = [SIPESchedule getScheduler];
    [scheduler sendData:data
              afterTime:timeout];
    return (__bridge gpointer) scheduler;
}

gpointer sipe_backend_schedule_mseconds(struct sipe_core_public *sipe_public,
                                        guint timeout,
                                        gpointer data)
{
    sipe_log_trace(@"%s",__FUNCTION__);
    SIPESchedule * scheduler = [SIPESchedule getScheduler];
    [scheduler sendData:data
              afterTime:(NSTimeInterval)(timeout / 1000)];
    return (__bridge gpointer) scheduler;
}

void sipe_backend_schedule_cancel(struct sipe_core_public *sipe_public,
                                  gpointer data)
{
    sipe_log_trace(@"%s",__FUNCTION__);
    SIPESchedule * scheduler = [SIPESchedule getScheduler];
    assert(scheduler);
    [scheduler cancel];
}

