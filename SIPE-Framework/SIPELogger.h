//
//  SIPELogger.h
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

#define SIPELOGGER_LEVEL_TRACE      1
#define SIPELOGGER_LEVEL_DEBUG      2
#define SIPELOGGER_LEVEL_INFO       3
#define SIPELOGGER_LEVEL_WARN       4
#define SIPELOGGER_LEVEL_ERROR      5
#define SIPELOGGER_LEVEL_FATAL      6

#define SIPELOGGER_LEVEL_TRACE_TEXT     @"[TRACE]:  "
#define SIPELOGGER_LEVEL_DEBUG_TEXT     @"[DEBUG]:  "
#define SIPELOGGER_LEVEL_INFO_TEXT      @"[INFO]:   "
#define SIPELOGGER_LEVEL_WARN_TEXT      @"[WARN]:   "
#define SIPELOGGER_LEVEL_ERROR_TEXT     @"[ERROR]:  "
#define SIPELOGGER_LEVEL_FATAL_TEXT     @"[FATAL]:  "
#define SIPELOGGER_LEVEL_UNKNOWN_TEXT   @"[UNKNOWN]:"

#define SIPELOGGER_FORMAT           "%@ %@"
#define SIPELOGGER_ENCODING [NSString defaultCStringEncoding]


// TODO - move should log to here...
#define SIPELOGGER_WRITE_ATLEVEL(level,format)      \
do {                                                \
    va_list args;                                   \
    va_start(args, format);                         \
    [self   write: level                            \
       withFormat: format                           \
        arguments: args];                           \
    va_end(args);                                   \
} while(false)                                      \


#ifdef DEBUG
#define SIPELOGGER_DEFAULT_LEVEL    SIPELOGGER_LEVEL_TRACE
#define SIPELOGGER_DEFAULT_ENABLED  YES
#define sipe_log(level,format,...)                                          \
    objc_msgSend([SIPELogger getLogger],                                    \
    @selector(level:),                                                      \
    [NSString stringWithFormat: @"%@ (%s)",                                 \
    format,strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__], \
    ##__VA_ARGS__)

#else
#define SIPELOGGER_DEFAULT_LEVEL    SIPELOGGER_LEVEL_ERROR
#define SIPELOGGER_DEFAULT_ENABLED  NO
#define sipe_log(level,format,...)          \
    objc_msgSend([SIPELogger getLogger],    \
    @selector(level:),                      \
    format,##__VA_ARGS__)

#endif

#define TRACE_LEVEL trace
#define DEBUG_LEVEL debug
#define INFO_LEVEL  info
#define WARN_LEVEL  warn
#define ERROR_LEVEL error
#define FATAL_LEVEL fatal

#define sipe_log_trace(f,...)  sipe_log(TRACE_LEVEL,f,##__VA_ARGS__)
#define sipe_log_debug(f,...)  sipe_log(DEBUG_LEVEL,f,##__VA_ARGS__)
#define sipe_log_info(f,...)   sipe_log(INFO_LEVEL,f,##__VA_ARGS__)
#define sipe_log_warn(f,...)   sipe_log(WARN_LEVEL,f,##__VA_ARGS__)
#define sipe_log_error(f,...)  sipe_log(ERROR_LEVEL,f,##__VA_ARGS__)
#define sipe_log_fatal(f,...)  sipe_log(FATAL_LEVEL,f,##__VA_ARGS__)


typedef int sipelogger_level;

@interface SIPELogger : NSObject

//===============================================================================
// Static Methods
//===============================================================================
+(instancetype) getLogger;

//===============================================================================
// Public Methods
//===============================================================================
-(void) write: (sipelogger_level) level
   withFormat: (NSString *) fmt, ...;
-(void) trace: (NSString * ) fmt, ...;
-(void) debug: (NSString * ) fmt, ...;
-(void) info: (NSString * ) fmt, ...;
-(void) warn: (NSString * ) fmt, ...;
-(void) error:  (NSString * ) fmt, ...;
-(void) fatal:  (NSString * ) fmt, ...;
-(NSString *) levelToString: (sipelogger_level) level;
-(BOOL) shouldLog: (sipelogger_level) level;


//===============================================================================
// Public Properties
//===============================================================================
@property (readwrite) BOOL              loggingEnabled;
@property (readwrite) sipelogger_level  logLevel;
@property (readonly) NSString *         logFormat;

@end
