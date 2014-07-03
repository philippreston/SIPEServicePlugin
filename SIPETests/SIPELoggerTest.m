//
//  SIPELoggerTest.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <glib.h>
#import "sipe-backend.h"
#import "SIPELogger.h"

@interface SIPELoggerTest : XCTestCase {
    SIPELogger * logger;
}

@end

@implementation SIPELoggerTest

- (void)setUp
{
    [super setUp];
    logger = [SIPELogger getLogger];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSameInstance
{
    SIPELogger * loggger2 = [SIPELogger getLogger];
    XCTAssertEqual(logger, loggger2);
}

- (void)testLoggingEnabled {
    [logger setLoggingEnabled:YES];
    XCTAssertTrue([logger loggingEnabled]);
    XCTAssertEqual(1,sipe_backend_debug_enabled());
    [logger setLoggingEnabled:NO];
    XCTAssertFalse([logger loggingEnabled]);
    XCTAssertEqual(0,sipe_backend_debug_enabled());
}

- (void)testLogLevel {

    [logger setLogLevel:SIPELOGGER_LEVEL_TRACE];
    XCTAssertEqual([logger logLevel], SIPELOGGER_LEVEL_TRACE);
    [logger setLogLevel:SIPELOGGER_LEVEL_DEBUG];
    XCTAssertEqual([logger logLevel], SIPELOGGER_LEVEL_DEBUG);
    [logger setLogLevel:SIPELOGGER_LEVEL_INFO];
    XCTAssertEqual([logger logLevel], SIPELOGGER_LEVEL_INFO);
    [logger setLogLevel:SIPELOGGER_LEVEL_WARN];
    XCTAssertEqual([logger logLevel], SIPELOGGER_LEVEL_WARN);
    [logger setLogLevel:SIPELOGGER_LEVEL_ERROR];
    XCTAssertEqual([logger logLevel], SIPELOGGER_LEVEL_ERROR);
    [logger setLogLevel:SIPELOGGER_LEVEL_FATAL];
    XCTAssertEqual([logger logLevel], SIPELOGGER_LEVEL_FATAL);
}

- (void)testLevelToString {
    XCTAssertEqualObjects(SIPELOGGER_LEVEL_TRACE_TEXT,[logger levelToString:SIPELOGGER_LEVEL_TRACE]);
    XCTAssertEqualObjects(SIPELOGGER_LEVEL_DEBUG_TEXT,[logger levelToString:SIPELOGGER_LEVEL_DEBUG]);
    XCTAssertEqualObjects(SIPELOGGER_LEVEL_INFO_TEXT,[logger levelToString:SIPELOGGER_LEVEL_INFO]);
    XCTAssertEqualObjects(SIPELOGGER_LEVEL_WARN_TEXT,[logger levelToString:SIPELOGGER_LEVEL_WARN]);
    XCTAssertEqualObjects(SIPELOGGER_LEVEL_ERROR_TEXT,[logger levelToString:SIPELOGGER_LEVEL_ERROR]);
    XCTAssertEqualObjects(SIPELOGGER_LEVEL_FATAL_TEXT,[logger levelToString:SIPELOGGER_LEVEL_FATAL]);
}

- (void)testShouldLog {

    BOOL result = NO;
    [logger setLogLevel: SIPELOGGER_LEVEL_INFO];

    [logger setLoggingEnabled: NO];
    result = [logger shouldLog:SIPELOGGER_LEVEL_TRACE];
    XCTAssertFalse(result, @"Disabled + Lower than Level should be false");

    [logger setLoggingEnabled: NO];
    result = [logger shouldLog:SIPELOGGER_LEVEL_INFO];
    XCTAssertFalse(result, @"Disabled + Equal to Level should be false");

    [logger setLoggingEnabled: NO];
    result = [logger shouldLog:SIPELOGGER_LEVEL_FATAL];
    XCTAssertFalse(result, @"Disabled + Higher than Level should be false");

    [logger setLoggingEnabled: YES];
    result = [logger shouldLog:SIPELOGGER_LEVEL_TRACE];
    XCTAssertFalse(result, @"Enabled + Lower than Level should be false");

    [logger setLoggingEnabled: YES];
    result = [logger shouldLog:SIPELOGGER_LEVEL_INFO];
    XCTAssertTrue(result, @"Enabled + Equal to Level should be true");

    [logger setLoggingEnabled: YES];
    result = [logger shouldLog:SIPELOGGER_LEVEL_FATAL];
    XCTAssertTrue(result, @"Enabled + Higher than Level should be true");
}

-(void) testMessageMethods
{

    [logger setLogLevel:SIPELOGGER_LEVEL_TRACE];
    [logger setLoggingEnabled:YES];

    [logger trace:@"A trace message"];
    [logger debug:@"A debug message"];
    [logger info:@"A info message"];
    [logger warn:@"A warning message"];
    [logger error:@"A error message"];
    [logger fatal:@"A fatal message"];

    sipe_backend_debug_literal(SIPE_DEBUG_LEVEL_INFO, "Logging Literal from C");

    // No test - just convienience method for checking
}

-(void) testFormattedMethods
{

    [logger setLogLevel:SIPELOGGER_LEVEL_TRACE];
    [logger setLoggingEnabled:YES];

    [logger trace:@"A formatted %@ message",@"trace"];
    [logger debug:@"A formatted %@ message",@"debug"];
    [logger info:@"A formatted %@ message",@"info"];
    [logger warn:@"A formatted %@ message",@"warn"];
    [logger error:@"A formatted %@ message",@"error"];
    [logger fatal:@"A formatted %@ message",@"fatal"];

    sipe_backend_debug(SIPE_DEBUG_LEVEL_INFO, "Logging from %s", "C function");

    // No test - just convienience method for checking
}

-(void) testMacroMessageMethods
{
    sipe_log(TRACE_LEVEL, @"A trace message");
    sipe_log(DEBUG_LEVEL, @"A debug message");
    sipe_log(INFO_LEVEL, @"A info message");
    sipe_log(WARN_LEVEL, @"A warn message");
    sipe_log(ERROR_LEVEL, @"A error message");
    sipe_log(FATAL_LEVEL, @"A fatal message");

    // No test - just convienience method for checking
}

-(void) testMacroFormatMethods
{
    sipe_log(TRACE_LEVEL, @"A formatted trace %@ message",@"BOO1");
    sipe_log(DEBUG_LEVEL, @"A formatted debug %@ message",@"BOO2");
    sipe_log(INFO_LEVEL, @"A formatted info %@ message",@"BOO3");
    sipe_log(WARN_LEVEL, @"A formatted warn %@ message",@"BOO4");
    sipe_log(ERROR_LEVEL, @"A formatted error %@ message",@"BOO5");
    sipe_log(FATAL_LEVEL, @"A formatted fatal %@ message",@"BOO6");

    // No test - just convienience method for checking
}

@end
