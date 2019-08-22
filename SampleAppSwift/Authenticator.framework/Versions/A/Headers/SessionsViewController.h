//
//  SessionsViewController.h
//  WhiteLabel
//
//  Created by ani on 5/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOASession.h"
#import "AuthenticatorManager.h"

typedef void (^Completion)(NSArray *array, NSError *error);
typedef void (^getSessionsCompletion)(NSArray<IOASession*> *array, NSError *error);

@interface SessionsViewController : UIViewController

/*!
 @brief Use this method to initialize the view in your parent app with the default Sessions View
 @discussion This method will push the default Sessions View on to the stack that displays a UITableView of all active sessions.
 @param parentViewController The current View Controller where you want the default Sessions View to be pushed on to.
 */
-(id)initWithParentView:(UIViewController*)parentViewController;
/*!
 @brief Use this method to retrieve the list of active sessions
 @discussion This method will return an NSArray in the getSessionsCompletion block that represents the list of IOASessions Objects which are the active sessions.
 @param block The getSessionsCompletion block that will return an NSArray in the getSessionsCompletion block that represents the list of IOASessions which are active sessions. If there is an error retrieving the list, an NSError object will be returned.
 */
-(void)getSessions:(getSessionsCompletion)block __attribute((deprecated("SessionsViewController.getSessions is being deprecated. Use LKSessionManager.getSessions instead")));
/*!
 @brief Use this method refresh the list of sessions in the TableView of the default Sessions View
 @discussion This method will refresh the list of sessions displayed in the TableView of the default Sessions View.
 */
-(void)refreshSessionsView;
/*!
 @brief Use this method refresh the list of sessions in the TableView of the default Sessions View
 @discussion This method will refresh the list of sessions displayed in the TableView of the default Sessions View.
 @param application The current View Controller where you want the default Sessions View to be pushed on to.
 */
-(void)clearSession:(IOASession*)application __attribute((deprecated("SessionsViewController.clearSession is being deprecated. For the same functionality, use LKSessionManager.endSession instead")));
/*!
 @brief Use this method end all active sessions
 @discussion This method will end all active sessions.
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)endAllSessions:(completion)completion __attribute((deprecated("SessionsViewController.endAllSessions is being deprecated. Use LKSessionManager.endAllSessions instead")));

@end
