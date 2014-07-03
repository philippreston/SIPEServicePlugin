//
//  SIPEBuddy.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-common.h"
#import "sipe-backend.h"
#import "SIPELogger.h"
#import "SIPEBuddy.h"

@implementation SIPEBuddy

@end

#pragma mark  -
#pragma mark SIPE C Backend BUDDY Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend BUDDY Functions
//===============================================================================
sipe_backend_buddy sipe_backend_buddy_find(struct sipe_core_public *sipe_public,
                                           const gchar *buddy_name,
                                           const gchar *group_name)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

GSList *sipe_backend_buddy_find_all(SIPE_UNUSED_PARAMETER struct sipe_core_public *sipe_public,
                                    const gchar *buddy_name,
                                    const gchar *group_name)
{

    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

gchar *sipe_backend_buddy_get_name(SIPE_UNUSED_PARAMETER struct sipe_core_public *sipe_public,
                                   const sipe_backend_buddy who)
{

    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

gchar *sipe_backend_buddy_get_alias(SIPE_UNUSED_PARAMETER struct sipe_core_public *sipe_public,
                                    const sipe_backend_buddy who)
{

    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

gchar *sipe_backend_buddy_get_server_alias(struct sipe_core_public *sipe_public,
                                           const sipe_backend_buddy who)
{

    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

gchar *sipe_backend_buddy_get_local_alias(struct sipe_core_public *sipe_public,
                                          const sipe_backend_buddy who)
{

    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

gchar *sipe_backend_buddy_get_group_name(SIPE_UNUSED_PARAMETER struct sipe_core_public *sipe_public,
                                         const sipe_backend_buddy who)
{

    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

gchar *sipe_backend_buddy_get_string(SIPE_UNUSED_PARAMETER struct sipe_core_public *sipe_public,
                                     sipe_backend_buddy who,
                                     const sipe_buddy_info_fields key)
{

    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

void sipe_backend_buddy_set_string(struct sipe_core_public *sipe_public,
                                   sipe_backend_buddy who,
                                   const sipe_buddy_info_fields key,
                                   const gchar *val)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_buddy_refresh_properties(struct sipe_core_public *sipe_public,
                                           const gchar *uri)
{
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

guint sipe_backend_buddy_get_status(struct sipe_core_public *sipe_public,
                                    const gchar *uri)
{

    // TODO: Implement
    return 0;
}

void sipe_backend_buddy_set_alias(struct sipe_core_public *sipe_public,
                                  const sipe_backend_buddy who,
                                  const gchar *alias)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_buddy_set_server_alias(SIPE_UNUSED_PARAMETER struct sipe_core_public *sipe_public,
                                         SIPE_UNUSED_PARAMETER const sipe_backend_buddy who,
                                         SIPE_UNUSED_PARAMETER const gchar *alias)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_buddy_list_processing_finish(struct sipe_core_public *sipe_public)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

sipe_backend_buddy sipe_backend_buddy_add(struct sipe_core_public *sipe_public,
                                          const gchar *name,
                                          const gchar *alias,
                                          const gchar *group_name)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

void sipe_backend_buddy_remove(struct sipe_core_public *sipe_public,
                               const sipe_backend_buddy who)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_buddy_set_status(struct sipe_core_public *sipe_public,
                                   const gchar *uri,
                                   guint activity)
{
    // TODO: Implement
}

gboolean sipe_backend_uses_photo(void)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
	return NO;
}

void sipe_backend_buddy_set_photo(struct sipe_core_public *sipe_public,
                                  const gchar *uri,
                                  gpointer image_data,
                                  gsize image_len,
                                  const gchar *photo_hash)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

const gchar *sipe_backend_buddy_get_photo_hash(struct sipe_core_public *sipe_public,
                                               const gchar *uri)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

gboolean sipe_backend_buddy_group_add(struct sipe_core_public *sipe_public,
                                      const gchar *group_name)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NO;
}

void sipe_backend_buddy_group_remove(struct sipe_core_public *sipe_public,
                                     const gchar *group_name)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}



