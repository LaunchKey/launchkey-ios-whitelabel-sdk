//
//  LocalAuthManager.h
//  Authenticator
//
//  Created by ani on 11/14/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKPolicy.h"

typedef void (^localAuthCompletion)(BOOL response, NSError *error);

static const int localAuthRequestExpirationDefault = 120;
static const int localAuthRequestExpirationMax = 300;

@interface LocalAuthManager : NSObject

+(LocalAuthManager*)sharedManager;

-(void)setTitle:(NSString*)title;
-(void)setExpiration:(int)expiration;
-(void)presentLocalAuth:(UINavigationController*)parentNavController withPolicy:(LKPolicy*)policy withCompletion:(localAuthCompletion)completion;

@end
