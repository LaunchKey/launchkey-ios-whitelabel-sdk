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

-(id)initWithParentView:(UIViewController*)parentViewController;

-(void)getSessions:(getSessionsCompletion)block;

-(void)refreshSessionsView;

-(void)clearSession:(IOASession*)application;

//End All Sessions
-(void)endAllSessions:(completion)completion;

@end
