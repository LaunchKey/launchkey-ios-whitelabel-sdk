//
//  LKCAPIRequestSpecs.h
//  AuthenticatorDynamicFramework
//
//  Created by Steven Gerhard on 12/17/19.
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

// Encapsulates instance variables that exist only as long as a single network request
@interface LKCAPIRequestSpecs : NSObject

@property(nonatomic,strong)NSString* path;
@property(nonatomic,strong)NSString* publicKeyForAPI;
@property(nonatomic,strong)NSString* kid;
@property(nonatomic,strong)NSString* bodyAsString;
@property(nonatomic,strong)NSMutableDictionary* bodyAsDictionary;
@property(nonatomic,strong)NSDictionary* headers;
@property(nonatomic,strong)NSString* jwtAudience;
@property(nonatomic,strong)NSString* jwtIssuer;
@property(nonatomic,strong)NSString* devicePublicKeyTag;
@property(nonatomic,strong)NSString* devicePrivateKeyTag;
@property(nonatomic,strong)NSString* signaturePublicKeyTag;
@property(nonatomic,strong)NSString* signaturePrivateKeyTag;
@property(nonatomic,strong)NSString* deviceID;
@property(nonatomic,strong)NSString* endpoint;
@property(nonatomic) BOOL doNotVerifyHeaders;

@end
