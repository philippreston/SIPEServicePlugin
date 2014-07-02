//
//  SIPEAccount.h
//  SIPEServicePlugin
//
//  Created by Philip Preston on 26/06/2014.
//  Copyright (c) 2014 ArkDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <glib.h>
#import "sipe-core.h"

//===============================================================================
// Typedefs
//===============================================================================
typedef enum {
    AUTO = SIPE_TRANSPORT_AUTO,
    SSL_TLS = SIPE_TRANSPORT_TLS,
    TCP = SIPE_TRANSPORT_TCP
} sipe_account_transport_type;

typedef enum {
    NTLM = SIPE_AUTHENTICATION_TYPE_NTLM,
    KRB5 = SIPE_AUTHENTICATION_TYPE_KERBEROS,
    TLSDSK = SIPE_AUTHENTICATION_TYPE_TLS_DSK
} sipe_account_authentication_scheme;

@interface SIPEAccount : NSObject

//===============================================================================
// Initialisers
//===============================================================================
-(instancetype) init;

//===============================================================================
// Methods
//===============================================================================
-(void) open;
-(void) close;
-(void) validate;
-(void) setServer:(NSString *) server WithPort:(NSString*) port;


//===============================================================================
// Properties
//===============================================================================
@property (readwrite) NSString * username;
@property (readwrite) NSString * password;
@property (readwrite) NSString * account;
@property (readwrite) NSString * email;
@property (readwrite) NSString * emailUrl;
@property (readwrite) NSString * domain;
@property (readwrite) sipe_account_authentication_scheme authentication;
@property (readwrite) BOOL singleSignOn;
@property (readonly) BOOL publishCalendar;
@property (readonly) struct sipe_core_public * sipePublic;

@property (readwrite) NSString * server;
@property (readwrite) NSString * port;
@property (readwrite) sipe_account_transport_type transport;


@end
