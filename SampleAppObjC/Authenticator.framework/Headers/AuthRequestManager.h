//
//  AuthRequestManager.h
//  WhiteLabel
//
//  Created by ani on 6/13/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^authRequestCompletion)(NSString *requestMessage, NSError *error);

@interface AuthRequestManager : NSObject

+(AuthRequestManager*)sharedManager;
/*!
 @brief Use this method to check for any pending Auth Requests
 @discussion This method will push the Auth Request View on to the stack if there are any pending Auth Requests.
 @param  parentNavigationController The current Navigation Controller where you want the Auth Request View to be pushed on to.
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)checkForPendingAuthRequest:(UINavigationController*)parentNavigationController withCompletion:(authRequestCompletion)completion;
/*!
 @brief Use this method to retrieve the title of the current Auth Request, if there is one
 @discussion This method will return the title of the current Auth Request, if there is one.
 @return NSString The NSString that represents the title of the current Auth Request, if there is one.
 */
-(NSString *)getAuthRequestTitle;
/*!
 @brief Use this method to retrieve the context of the current Auth Request, if there is one
 @discussion This method will return the context of the current Auth Request, if there is one.
 @return NSString The NSString that represents the context of the current Auth Request, if there is one.
 */
-(NSString *)getAuthRequestContext;
/*!
 @brief Use this method to retrieve the time that the current Auth Request was created at, if there is one
 @discussion This method will return the time that the current Auth Request was created at, if there is one, in milliseconds.
 @return int The int value that represents the time that the current Auth Request was created at, if there is one, in milliseconds.
 */
-(int)getCreatedAtInMilliseconds;
/*!
 @brief Use this method to retrieve the time that the current Auth Request will expire at, if there is one
 @discussion This method will return the time that the current Auth Request will expire at, if there is one, in milliseconds.
 @return int The int value that represents the expiration time of the current Auth Request, if there is one, in milliseconds.
 */
-(int)getExpiresAtInMilliseconds;

@end
