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

extern NSString *const requestApproved;
extern NSString *const requestDenied;
extern NSString *const possibleOldRequest;
extern NSString *const requestHidden;

@interface AuthRequestViewController : UIViewController

@property (nonatomic, copy) successBlock thisSuccess;
@property (nonatomic, copy) failureBlock thisFailure;

-(id)initWithParentView:(UIViewController*)parentViewController;
-(void)showRequest:(UIViewController*)parentViewController withSucess:(successBlock)success withFailure:(failureBlock)failure;

@end