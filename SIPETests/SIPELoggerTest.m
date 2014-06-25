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
    XCTAssertEqualObjects(@"TRACE",[logger levelToString:SIPELOGGER_LEVEL_TRACE]);
    XCTAssertEqualObjects(@"DEBUG",[logger levelToString:SIPELOGGER_LEVEL_DEBUG]);
    XCTAssertEqualObjects(@"INFO",[logger levelToString:SIPELOGGER_LEVEL_INFO]);
    XCTAssertEqualObjects(@"WARN",[logger levelToString:SIPELOGGER_LEVEL_WARN]);
    XCTAssertEqualObjects(@"ERROR",[logger levelToString:SIPELOGGER_LEVEL_ERROR]);
    XCTAssertEqualObjects(@"FATAL",[logger levelToString:SIPELOGGER_LEVEL_FATAL]);
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

    [logger traceMessage:@"A trace message"];
    [logger debugMessage:@"A debug message"];
    [logger infoMessage:@"A info message"];
    [logger warnMessage:@"A warning message"];
    [logger errorMessage:@"A error message"];
    [logger fatalMessage:@"A fatal message"];

    // No test - just convienience method
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

    // No test - just convienience method
}

@end
