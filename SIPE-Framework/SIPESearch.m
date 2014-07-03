//
//  SIPESearch.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPELogger.h"
#import "SIPESearch.h"

@implementation SIPESearch

@end

#pragma mark  -
#pragma mark SIPE C Backend SEARCH Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend SEARCH Functions
//===============================================================================
void sipe_backend_search_failed(struct sipe_core_public *sipe_public,
                                struct sipe_backend_search_token *token,
                                const gchar *msg)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

struct sipe_backend_search_results *sipe_backend_search_results_start(struct sipe_core_public *sipe_public,
                                                                      struct sipe_backend_search_token *token)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

void sipe_backend_search_results_add(struct sipe_core_public *sipe_public,
                                     struct sipe_backend_search_results *results,
                                     const gchar *uri,
                                     const gchar *name,
                                     const gchar *company,
                                     const gchar *country,
                                     const gchar *email)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_search_results_finalize(struct sipe_core_public *sipe_public,
                                          struct sipe_backend_search_results *results,
                                          const gchar *description,
                                          gboolean more)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}
