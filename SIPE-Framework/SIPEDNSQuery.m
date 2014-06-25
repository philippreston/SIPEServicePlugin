//
//  SIPEDNSQuery.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPEDNSQuery.h"

@implementation SIPEDNSQuery

@end

#pragma mark  -
#pragma mark SIPE C Backend DNSQUERY Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend CONNECTION Functions
//===============================================================================
struct sipe_dns_query *sipe_backend_dns_query_srv(struct sipe_core_public *sipe_public,
                                                  const gchar *protocol,
                                                  const gchar *transport,
                                                  const gchar *domain,
                                                  sipe_dns_resolved_cb callback,
                                                  gpointer data)
{
    // TODO: Implement
    return NULL;
}

struct sipe_dns_query *sipe_backend_dns_query_a(struct sipe_core_public *sipe_public,
                                                const gchar *hostname,
                                                guint port,
                                                sipe_dns_resolved_cb callback,
                                                gpointer data)
{
    // TODO: Implement
    return NULL;
}

void sipe_backend_dns_query_cancel(struct sipe_dns_query *query)
{
    // TODO: Implement
}