//
//  SIPEConnection.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPEConnection.h"

@implementation SIPEConnection

@end


#pragma mark  -
#pragma mark SIPE C Backend CONNECTION Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend CONNECTION Functions
//===============================================================================
void sipe_backend_connection_completed(struct sipe_core_public *sipe_public)
{
    // TODO: Implement
}

void sipe_backend_connection_error(struct sipe_core_public *sipe_public,
                                   sipe_connection_error error,
                                   const gchar *msg)
{
    // TODO: Implement
}

gboolean sipe_backend_connection_is_disconnecting(struct sipe_core_public *sipe_public)
{
    // TODO: Implement
    return NO;
}

gboolean sipe_backend_connection_is_valid(struct sipe_core_public *sipe_public)
{
    // TODO: Implement
    return NO;
}

#pragma mark  -
#pragma mark SIPE C Backend NETWORK Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend NETWORK Functions
//===============================================================================
const gchar *sipe_backend_network_ip_address(struct sipe_core_public *sipe_public)
{
    // TODO: Implement
    return NULL;
}

struct sipe_backend_listendata * sipe_backend_network_listen_range(unsigned short port_min,
                                  unsigned short port_max,
                                  sipe_listen_start_cb listen_cb,
                                  sipe_client_connected_cb connect_cb,
                                  gpointer data)
{
    // TODO: Implement
    return NULL;
}
void sipe_backend_network_listen_cancel(struct sipe_backend_listendata *ldata)
{
    // TODO: Implement
}

gboolean sipe_backend_fd_is_valid(struct sipe_backend_fd *fd)
{
    // TODO: Implement
    return NO;
}

void sipe_backend_fd_free(struct sipe_backend_fd *fd)
{
    // TODO: Implement
}

// TODO: Network Callbacks

#pragma mark  -
#pragma mark SIPE C Backend SETTINGS Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend SETTINGS Functions
//===============================================================================
const gchar *sipe_backend_setting(struct sipe_core_public *sipe_public,
                                  sipe_setting type)
{
    return NULL;
}
