//
//  SIPESchedule.h
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <glib.h>

@interface SIPESchedule : NSObject

//===============================================================================
// Static Methods
//===============================================================================
+(instancetype) getScheduler;

//===============================================================================
// Public Methods
//===============================================================================
-(void) sendData: (gpointer) data afterTime: (NSTimeInterval) time;
-(void) cancel;
@end
