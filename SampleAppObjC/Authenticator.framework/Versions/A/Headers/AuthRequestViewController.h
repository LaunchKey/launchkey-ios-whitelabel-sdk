//
//  AuthRequestViewController.h
//  WhiteLabel
//
//  Created by ani on 6/13/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthRequestManager.h"

typedef void (^failureBlock)(NSString *errorMessage, NSString *errorCode);

@interface AuthRequestViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController __attribute((deprecated("The 'AuthRequestViewController' class and methods are being deprecated.")));
-(void)checkForPendingAuthRequest:(UINavigationController*)parentNavigationController withCompletion:(authRequestCompletion)completion __attribute((deprecated("The 'AuthRequestViewController' class and methods are being deprecated. Please import 'AuthRequestManager' and use -checkForPendingAuthRequest from that class.")));

@end
