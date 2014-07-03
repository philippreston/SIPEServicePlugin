//
//  SIPELogger.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

//===============================================================================
// Imports
//===============================================================================
#import <glib.h>
#import "sipe-backend.h"
#import "SIPELogger.h"
#import "SIPEHelpers.h"

// Handle for C API
SIPELogger * refSIPELogger;

//===============================================================================
// Private Prototypes
//===============================================================================
static sipelogger_level sipe_core_to_SIPELogger_level(sipe_debug_level level);



@interface SIPELogger()
@property (readwrite) NSString *    logFormat;
@end

@implementation SIPELogger

+(instancetype) getLogger
{
    static SIPELogger * logger;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        logger = [SIPELogger new];
    });

    return logger;
}

-(instancetype) init
{
    if (self = [super init]) {
        [self setLoggingEnabled: SIPELOGGER_DEFAULT_ENABLED];
        [self setLogLevel: SIPELOGGER_DEFAULT_LEVEL];
        [self setLogFormat: @SIPELOGGER_FORMAT];
    }

    // Initialise reference for c
    refSIPELogger = self;
    return self;
}

-(void) write: (sipelogger_level) level
   withFormat: (NSString *) fmt, ...
{
    SIPELOGGER_WRITE_ATLEVEL(level,fmt);
}

-(void) write: (sipelogger_level) level
   withFormat: (NSString *) fmt
    arguments: (va_list) args
{
    NSString * levelString = [self levelToString:level];
    if ([self shouldLog:level]) {
        NSString * msg = [[NSString alloc] initWithFormat:fmt
                                                arguments:args];
        NSLog([self logFormat],levelString,msg);
    }

}

-(void) trace: (NSString * ) fmt, ...
{
    SIPELOGGER_WRITE_ATLEVEL(SIPELOGGER_LEVEL_TRACE,fmt);
}

-(void) debug: (NSString * ) fmt, ...
{
    SIPELOGGER_WRITE_ATLEVEL(SIPELOGGER_LEVEL_DEBUG,fmt);
}

-(void) info:   (NSString * ) fmt, ...
{
    SIPELOGGER_WRITE_ATLEVEL(SIPELOGGER_LEVEL_INFO,fmt);
}

-(void) warn:   (NSString * ) fmt, ...
{
    SIPELOGGER_WRITE_ATLEVEL(SIPELOGGER_LEVEL_WARN,fmt);
}

-(void) error: (NSString * ) fmt, ...
{
    SIPELOGGER_WRITE_ATLEVEL(SIPELOGGER_LEVEL_ERROR,fmt);
}

-(void) fatal:  (NSString * ) fmt, ...
{
    SIPELOGGER_WRITE_ATLEVEL(SIPELOGGER_LEVEL_FATAL,fmt);
}

-(NSString *) levelToString: (sipelogger_level) level
{
    NSString * string;
    switch (level) {
        case SIPELOGGER_LEVEL_TRACE:
            string = SIPELOGGER_LEVEL_TRACE_TEXT;
            break;
        case SIPELOGGER_LEVEL_DEBUG:
            string = SIPELOGGER_LEVEL_DEBUG_TEXT;
            break;
        case SIPELOGGER_LEVEL_INFO:
            string = SIPELOGGER_LEVEL_INFO_TEXT;
            break;
        case SIPELOGGER_LEVEL_WARN:
            string = SIPELOGGER_LEVEL_WARN_TEXT;
            break;
        case SIPELOGGER_LEVEL_ERROR:
            string = SIPELOGGER_LEVEL_ERROR_TEXT;
            break;
        case SIPELOGGER_LEVEL_FATAL:
            string = SIPELOGGER_LEVEL_FATAL_TEXT;
            break;
        default:
            string = SIPELOGGER_LEVEL_UNKNOWN_TEXT;
            break;
    }
    return string;
}

-(BOOL) shouldLog: (sipelogger_level) level
{
    return _loggingEnabled && (level >= _logLevel);
}

@end

#pragma mark  -
#pragma mark SIPE C Backend DEBUG Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend DEBUG Functions
//===============================================================================

/*
 Mapping between the sipe backend debugger is as follows
 
    - SIPE_DEBUG_LEVEL_INFO     --> SIPELOGGER_LEVEL_DEBUG
    - SIPE_DEBUG_LEVEL_WARNING  --> SIPELOGGER_LEVEL_WARN
    - SIPE_DEBUG_LEVEL_ERROR    --> SIPELOGGER_LEVEL_ERROR
    - SIPE_DEBUG_LEVEL_FATAL    --> SIPELOGGER_LEVEL_FATAL
 
Making INFO from the core as debug as we dont want that on all the time
 */

static sipelogger_level sipe_core_to_SIPELogger_level(sipe_debug_level level)
{

    // TODO - option to disable backend logging - only front

    switch(level) {
        case SIPE_DEBUG_LEVEL_INFO:
            return SIPELOGGER_LEVEL_DEBUG;
        case SIPE_DEBUG_LEVEL_WARNING:
            return SIPELOGGER_LEVEL_WARN;
        case SIPE_DEBUG_LEVEL_ERROR:
            return SIPELOGGER_LEVEL_ERROR;
        case SIPE_DEBUG_LEVEL_FATAL:
            return SIPELOGGER_LEVEL_FATAL;
    }
}

gboolean sipe_backend_debug_enabled(void)
{
    return [refSIPELogger loggingEnabled];
}

void sipe_backend_debug_literal(sipe_debug_level level,
                                const gchar *msg)
{
    sipelogger_level logAtLevel =  sipe_core_to_SIPELogger_level(level);
    [refSIPELogger write:logAtLevel
              withFormat:@"%@", GCHAR_TO_NSSTRING(msg)];
}

void sipe_backend_debug(sipe_debug_level level,
                        const gchar *format,
                        ...)
{
    va_list args;                                   \
    va_start(args, format);
    sipelogger_level logAtLevel =  sipe_core_to_SIPELogger_level(level);
    [refSIPELogger write:logAtLevel
              withFormat: GCHAR_TO_NSSTRING(format)
               arguments: args];
}