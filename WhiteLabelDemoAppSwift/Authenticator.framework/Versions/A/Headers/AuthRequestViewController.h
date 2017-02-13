//
//  AuthRequestViewController.h
//  WhiteLabel
//
//  Created by ani on 6/13/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^successBlock)();
typedef void (^failureBlock)(NSString *errorMessage, NSString *errorCode);
typedef void (^authRequestCompletion)(NSString *requestMessage, NSError *error);

extern NSString *const requestApproved;
extern NSString *const requestDenied;
extern NSString *const requestHidden;

@interface AuthRequestViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController;
-(void)checkForPendingAuthRequest:(UINavigationController*)parentNavigationController withCompletion:(authRequestCompletion)completion;

@end
