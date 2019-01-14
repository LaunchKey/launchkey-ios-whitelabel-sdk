//
//  AuthRequestManager.h
//  WhiteLabel
//
//  Created by ani on 6/13/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^authRequestCompletion)(NSString *requestMessage, NSError *error);

extern NSString *const requestApproved;
extern NSString *const requestDenied;

@interface AuthRequestManager : NSObject

+(AuthRequestManager*)sharedManager;

-(void)checkForPendingAuthRequest:(UINavigationController*)parentNavigationController withCompletion:(authRequestCompletion)completion;
-(NSString *)getAuthRequestTitle;
-(NSString *)getAuthRequestContext;
-(int)getCreatedAtInMilliseconds;
-(int)getExpiresAtInMilliseconds;

@end
