//
//  SIPEHelpers.h
//  SIPEServicePlugin
//
//  Created by Philip Preston on 30/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import "sipe-core.h"

#define ASSERT_NOT_NIL(v,m)                                                 \
do {                                                                        \
    if(!v)                                                                  \
    {                                                                       \
        @throw [NSException exceptionWithName: NSInvalidArgumentException   \
                                reason: m                                   \
                              userInfo: nil];                               \
    }                                                                       \
} while(false)                                                              \


#define SIPE_ENCODING               [NSString defaultCStringEncoding]
#define NSSTRING_TO_GCHAR(m)        (gchar *)[m cStringUsingEncoding: SIPE_ENCODING]
#define GCHAR_TO_NSSTRING(c)        [NSString stringWithCString:c encoding:SIPE_ENCODING]

#define SIPE_PUBLIC_TO_IMSERVICE    (__bridge SIPEService *) sipe_public->backend_private
#define SIPE_TRANSPORT_TO_IMSERVICE (__bridge SIPEService *) ((struct sipe_core_public *)conn->user_data)->backend_private