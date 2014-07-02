//
//  SIPETransport.h
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <glib.h>
#import "sipe-core.h"
#import "sipe-backend.h"

//===============================================================================
// Typedefs
//===============================================================================
typedef NS_ENUM(NSUInteger, SIPETransportStatus) {
    SIPETransportStatusNotOpen = 0,
    SIPETransportStatusOpening = 1,
    SIPETransportStatusOpen = 2,
    SIPETransportStatusReading = 3,
    SIPETransportStatusWriting = 4,
    SIPETransportStatusAtEnd = 5,
    SIPETransportStatusClosed = 6,
    SIPETransportStatusError = 7
};

@interface SIPETransport : NSObject <NSStreamDelegate>

//===============================================================================
// Public Initialisers
//===============================================================================
-(instancetype) init;

//===============================================================================
// Public Methods
//===============================================================================
-(void) connect:(struct sipe_core_public*) sipe_public  WithSetup:(const sipe_connect_setup*) setup;
-(void) disconnect;
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;

//===============================================================================
// Public Properties
//===============================================================================
@property (readwrite) struct sipe_transport_connection * connection;
@property (readwrite) SIPETransportStatus status;

@end
