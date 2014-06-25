//
//  SIPEServicePlugin.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 19/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import "SIPEServicePlugin.h"
#import "SIPEService.h"

@interface SIPEServicePlugin()
// Private Properties
//@property (nonatomic) SIPEService * IMService;
@end

@implementation SIPEServicePlugin


#pragma mark  -
#pragma mark Static Functions
#pragma mark  -
//===============================================================================
// Static Functions
//===============================================================================
+ (void)initialize
{
    NSLog(@"SIPEService: Init");
}


#pragma mark  -
#pragma mark IMServicePlugIn
#pragma mark  -
//===============================================================================
// IM ServicePlugIn Implementations
//===============================================================================
- (instancetype) initWithServiceApplication: (id <IMServiceApplication,
                                    IMServiceApplicationGroupListSupport,
                                    IMServiceApplicationInstantMessagingSupport>) serviceApplication
{
	if ((self = [super init]))
    {
        NSLog(@"SIPEService: Initialising Plugin");
   //     _IMService = [SIPEService new];
	}

	return self;
}


- (oneway void) login
{
    NSLog(@"SIPEService: Login");
//    [self.IMService login];
}


- (oneway void) logout
{
    NSLog(@"SIPEService: Logout");
}


- (oneway void) updateAccountSettings: (NSDictionary *) accountSettings
{
    NSLog(@"SIPEService: Update Account Settings");
}


#pragma mark  -
#pragma mark IMServicePlugInInstantMessagingSupport
#pragma mark  -
//===============================================================================
// IM IMServicePlugInInstantMessagingSupport Implementations
//===============================================================================
- (oneway void)sendMessage:(IMServicePlugInMessage *)message
                  toHandle:(NSString *)handle
{

}


- (oneway void)userDidStartTypingToHandle:(NSString *)handle
{

}


- (oneway void)userDidStopTypingToHandle:(NSString *)handle
{
    
}

#pragma mark  -
#pragma mark IMServicePlugInPresenceSupport
#pragma mark  -
//===============================================================================
// IM IMServicePlugInPresenceSupport Implementations
//===============================================================================
- (oneway void)updateSessionProperties:(NSDictionary *)properties
{
    NSLog(@"Update Session Properties List");
}


#pragma mark  -
#pragma mark IMServicePlugInGroupListSupport
#pragma mark  -
//===============================================================================
// IM IMServicePlugInGroupListSupport Implementations
//===============================================================================
- (oneway void) requestGroupList
{

}

#pragma mark  -
#pragma mark IMServicePlugInGroupListEditingSupport
#pragma mark  -
//===============================================================================
// IM IMServicePlugInGroupListEditingSupport Implementations
//===============================================================================
- (oneway void) addGroups:(NSArray *)groupNames
{

}


- (oneway void) removeGroups:(NSArray *)groupNames
{

}


- (oneway void) renameGroup:(NSString *)oldGroupName
                    toGroup:(NSString *)newGroupName
{

}


- (oneway void) addHandles:(NSArray *)handles
                   toGroup:(NSString *)groupName
{

}

- (oneway void) removeHandles:(NSArray *)handles
                    fromGroup:(NSString *)groupName
{

}


#pragma mark  -
#pragma mark IMServicePlugInGroupListOrderingSupport
#pragma mark  -
//===============================================================================
// IM IMServicePlugInGroupListOrderingSupport Implementations
//===============================================================================
- (oneway void)reorderGroups:(NSArray *)groupNames
{

}


- (oneway void)reorderHandles:(NSArray *)handles
                      inGroup:(NSString *)groupName
{

}


#pragma mark  -
@end
