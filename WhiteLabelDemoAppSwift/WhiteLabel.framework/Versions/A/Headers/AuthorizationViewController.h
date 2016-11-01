//
//  AuthorizationViewController.h
//  WhiteLabel
//
//  Created by ani on 5/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKWApplication.h"

typedef void (^Completion)(NSArray *array, NSError *error);
typedef void (^getApplicationsCompletion)(NSArray<LKWApplication*> *array, NSError *error);

@interface AuthorizationViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController;

-(void)getAuthorizations:(Completion)block __attribute((deprecated("Use -getApplications:")));

-(void)getApplications:(getApplicationsCompletion)block;

-(void)refreshAuthsView;

-(void)setNoAuthsLabelTextColor:(UIColor*)color;

-(void)hideNoAuthsLabel:(BOOL)hide;

-(void)clearAuthorization:(NSInteger)cellIndex __attribute((deprecated("Use -clearApplication:")));

-(void)clearApplication:(LKWApplication*)application;

@end