//
//  SIPEAccountTest.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 30/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <glib.h>
#import "sipe-core.h"
#import "SIPELogger.h"
#import "SIPEAccount.h"

@interface SIPEAccountTest : XCTestCase {
    SIPEAccount * account;
    SIPELogger * logger;
}

@end

@implementation SIPEAccountTest

- (void)setUp
{
    [super setUp];

    // Get the logger
    logger = [SIPELogger getLogger];
    [logger setLoggingEnabled:YES];
    [logger setLogLevel:SIPELOGGER_LEVEL_DEBUG];

    // Need an instance then open sipe.
    account = [SIPEAccount new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidate
{
    NSString * username = @"ppreston";
    NSString * password = @"password123";
    NSString * accountName = @"p.mac.com@reuters.net";

    [self setUsername:nil Password:password Account: accountName];
    XCTAssertThrowsSpecificNamed([account validate],
                                 NSException,
                                 NSInvalidArgumentException,
                                 @"Nil username should throw exception");


    [self setUsername:username Password:nil Account: accountName];
    XCTAssertThrowsSpecificNamed([account validate],
                                 NSException,
                                 NSInvalidArgumentException,
                                 @"Nil password should throw exception");


    [self setUsername:username Password:password Account: nil];
    XCTAssertThrowsSpecificNamed([account validate],
                                 NSException,
                                 NSInvalidArgumentException,
                                 @"Nil username should throw exception");

    [self setUsername:username Password:password Account: accountName];
    XCTAssertNoThrowSpecificNamed([account validate],
                                 NSException,
                                 NSInvalidArgumentException,
                                 @"Validation should not fail");
}

-(void) setUsername:(NSString *) u
           Password:(NSString*) p
            Account:(NSString*) a
{
    [account setUsername:u];
    [account setPassword:p];
    [account setAccount:a];

}


@end
