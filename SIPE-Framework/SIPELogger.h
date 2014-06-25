//
//  SIPELogger.h
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SIPELOGGER_LEVEL_TRACE      1
#define SIPELOGGER_LEVEL_DEBUG      2
#define SIPELOGGER_LEVEL_INFO       3
#define SIPELOGGER_LEVEL_WARN       4
#define SIPELOGGER_LEVEL_ERROR      5
#define SIPELOGGER_LEVEL_FATAL      6
#define SIPELOGGER_DEFAULT_LEVEL    SIPELOGGER_LEVEL_ERROR
#define SIPELOGGER_FORMAT           "[%@]:\t%@"

#define SIPELOGGER_WRITE_ATLEVEL(level,format)      \
do {                                                \
    va_list args;                                   \
    va_start(args, format);                         \
    [self   write: level                            \
       withFormat: format                           \
        arguments: args];                           \
}while(false)                                       \


typedef int sipelogger_level;

@interface SIPELogger : NSObject

//===============================================================================
// Static Methods
//===============================================================================
+(instancetype) getLogger;

//===============================================================================
// Methods
//===============================================================================
-(void) write: (sipelogger_level) level
   withFormat: (NSString *) fmt
    arguments: (va_list) args;
-(void) trace: (NSString * ) fmt, ...;
-(void) traceMessage: (NSString * ) msg;
-(void) debug: (NSString * ) fmt, ...;
-(void) debugMessage:  (NSString * ) msg;
-(void) info: (NSString * ) fmt, ...;
-(void) infoMessage: (NSString * ) msg;
-(void) warn: (NSString * ) fmt, ...;
-(void) warnMessage: (NSString * ) msg;
-(void) error:  (NSString * ) fmt, ...;
-(void) errorMessage: (NSString * ) msg;
-(void) fatal:  (NSString * ) fmt, ...;
-(void) fatalMessage: (NSString * ) msg;
-(NSString *) levelToString: (sipelogger_level) level;
-(BOOL) shouldLog: (sipelogger_level) level;





//===============================================================================
// Properties
//===============================================================================
@property (readwrite) BOOL              loggingEnabled;
@property (readwrite) sipelogger_level  logLevel;
@property (readonly) NSString *         logFormat;

@end
