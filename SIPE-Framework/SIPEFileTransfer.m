//
//  SIPEFileTransfer.m
//  SIPEServicePlugin
//
//  Created by Philip Preston on 25/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <glib.h>
#import "sipe-backend.h"
#import "SIPELogger.h"
#import "SIPEFileTransfer.h"

@implementation SIPEFileTransfer

@end


#pragma mark  -
#pragma mark SIPE C Backend FILETRANSFER Functions
#pragma mark  -
//===============================================================================
// SIPE C Backend FILETRANSFER Functions
//===============================================================================
void sipe_backend_ft_error(struct sipe_file_transfer *ft,
                           const gchar *errmsg)
{
    // TODO Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

const gchar *sipe_backend_ft_get_error(struct sipe_file_transfer *ft)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NULL;
}

void sipe_backend_ft_deallocate(struct sipe_file_transfer *ft)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

gssize sipe_backend_ft_read(struct sipe_file_transfer *ft,
                            guchar *data,
                            gsize size)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return 0;
}

gssize sipe_backend_ft_write(struct sipe_file_transfer *ft,
                             const guchar *data,
                             gsize size)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return 0;
}

void sipe_backend_ft_cancel_local(struct sipe_file_transfer *ft)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_ft_cancel_remote(struct sipe_file_transfer *ft)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_ft_incoming(struct sipe_core_public *sipe_public,
                              struct sipe_file_transfer *ft,
                              const gchar *who,
                              const gchar *file_name,
                              gsize file_size)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

void sipe_backend_ft_start(struct sipe_file_transfer *ft,
                           struct sipe_backend_fd *fd,
                           const char* ip, unsigned port)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
}

gboolean sipe_backend_ft_is_incoming(struct sipe_file_transfer *ft)
{
    // TODO: Implement
    sipe_log_trace(@"--> %s",__FUNCTION__);
    return NO;
}
