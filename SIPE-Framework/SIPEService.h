//
//  SIPEService.h
//  SIPEService
//
//  Created by Philip Preston on 20/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IMServicePlugIn/IMServicePlugIn.h>

@interface SIPEService : NSObject {
    
}

//===============================================================================
// Initialisers
//===============================================================================
-(instancetype) init;

//===============================================================================
// Methods
//===============================================================================
-(void) login;
-(void) logout;

//===============================================================================
// Properties
//===============================================================================
@property (readonly) NSString * version;
@property (readonly) NSDictionary * mainBundle;

@end
