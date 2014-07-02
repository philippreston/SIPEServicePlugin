//
//  SIPEConnection.h
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIPEAccount;
@class SIPETransport;

@interface SIPEConnection : NSObject

//===============================================================================
// Initialisers
//===============================================================================
-(instancetype) initWithAccount: (SIPEAccount *) account;

//===============================================================================
// Methods
//===============================================================================
-(void) start;
-(void) stop;

//===============================================================================
// Properties
//===============================================================================
@property (weak,readwrite) SIPEAccount * account;
@property (readwrite) SIPETransport * transport;
@property (readwrite,getter=isDisconnecting) BOOL disconnecting;
@property (readwrite,getter=isConnected) BOOL connected;

@end
