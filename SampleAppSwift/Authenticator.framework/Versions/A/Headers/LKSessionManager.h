//
//  LKSessionManager.h
//  Authenticator
//
//  Created by Steven Gerhard on 8/13/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOASession.h"

typedef void (^endSessionCompletion)(NSError *error);
typedef void (^getSessionsCompletion)(NSArray<IOASession*> *array, NSError *error);

@interface LKSessionManager : NSObject
/*!
 @brief Use this method to retrieve the list of active sessions
 @discussion This method will return an NSArray in the getSessionsCompletion block that represents the list of IOASessions Objects which are the active sessions.
 @param block The getSessionsCompletion block that will return an NSArray in the getSessionsCompletion block that represents the list of IOASessions which are active sessions. If there is an error retrieving the list, an NSError object will be returned. Completion passed in will always be executed.
 */
+(void)getSessions:(getSessionsCompletion)block;
/*!
 @brief Use this method to end a single session.
 @discussion This method will end the passed in session.
 @param session The session to end
 @param  completion The completion block of this method. Completion passed in will always be executed.
 */
+(void)endSession:(IOASession*)session completion:(endSessionCompletion)completion;
/*!
 @brief Use this method to end all active sessions
 @discussion This method will end all active sessions.
 @param  completion The completion block of this method. Completion passed in will always be executed.
 */
+(void)endAllSessions:(endSessionCompletion)completion;

@end
