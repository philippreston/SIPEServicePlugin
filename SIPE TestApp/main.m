//
//  main.m
//  SIPE TestApp
//
//  Created by Philip Preston on 01/07/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIPELogger.h"
#import "SIPEService.h"
#import "SIPEAccount.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {

        sipe_log_info(@"Starting the SIPE TestApp");

        // Create an account
        NSString * username = @"ppreston@nyx.com";
        NSString * password = @"ge6ra5as";
        NSString * accountName = @"ppreston.nyx.com@reuters.net";
        NSString * server = @"sip.reuters.net";
        NSString * port = @"443";

        SIPEAccount * account = [SIPEAccount new];
        [account setUsername:username];
        [account setPassword:password];
        [account setAccount:accountName];
        [account setServer:server WithPort:port];
        [account setTransport:SSL_TLS];
        [account setSingleSignOn:NO];
        [account setAuthentication:NTLM];
        sipe_log_info(@"Creating account: %@", account);

        // Create an IM instance
        SIPEService * imService = [SIPEService new];
        [imService loginWithAccount:account];

        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];

        [imService logout];

        
    }
    return 0;
}

