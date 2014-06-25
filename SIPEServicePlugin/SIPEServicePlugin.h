//
//  SIPEServicePlugin.h
//  SIPEServicePlugin
//
//  Created by Philip Preston on 19/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IMServicePlugIn/IMServicePlugIn.h>


@class SIPEService;

@interface SIPEServicePlugin : NSObject    <IMServicePlugIn,
                                            IMServicePlugInGroupListSupport,
                                            IMServicePlugInGroupListEditingSupport,
                                            IMServicePlugInGroupListOrderingSupport,
                                            IMServicePlugInPresenceSupport,
                                            IMServicePlugInInstantMessagingSupport>



@end
