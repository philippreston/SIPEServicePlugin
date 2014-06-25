//
//  SIPETransport.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPETransport.h"

@implementation SIPETransport

@end

#pragma mark  -
#pragma mark SIPE C Backend TRANSPORT Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend TRANSPORTs Functions
//===============================================================================
struct sipe_transport_connection *sipe_backend_transport_connect(struct sipe_core_public *sipe_public,
                                                                 const sipe_connect_setup *setup)
{
    // TODO: Implement
    return NULL;
}

void sipe_backend_transport_disconnect(struct sipe_transport_connection *conn)
{
    // TODO: Implement
}

void sipe_backend_transport_message(struct sipe_transport_connection *conn,
                                    const gchar *buffer)
{
    // TODO: Implement
}

void sipe_backend_transport_flush(struct sipe_transport_connection *conn)
{
    // TODO: Implement
}
