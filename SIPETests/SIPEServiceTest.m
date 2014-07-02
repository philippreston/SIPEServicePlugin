//
//  SIPEServiceTest.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 26/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <glib.h>
#import "SIPEService.h"

@interface SIPEServiceTest : XCTestCase {
    SIPEService * _service;
}

@end

@implementation SIPEServiceTest

- (void)setUp
{
    [super setUp];
    _service = [SIPEService new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLogin
{
    [_service login];
}

@end
