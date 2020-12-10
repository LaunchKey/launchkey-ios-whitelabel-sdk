//
//  SessionsViewController.h
//  WhiteLabel
//
//  Created by ani on 5/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticatorManager.h"

typedef void (^Completion)(NSArray *array, NSError *error);

@interface SessionsViewController : UIViewController

/*!
 @brief Use this method to initialize the view in your parent app with the default Sessions View
 @discussion This method will push the default Sessions View on to the stack that displays a UITableView of all active sessions.
 @param parentViewController The current View Controller where you want the default Sessions View to be pushed on to.
 */
-(id)initWithParentView:(UIViewController*)parentViewController;
/*!
 @brief Use this method refresh the list of sessions in the TableView of the default Sessions View
 @discussion This method will refresh the list of sessions displayed in the TableView of the default Sessions View.
 */
-(void)refreshSessionsView;

@end
