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
typedef void (^completion)(NSError *error);

extern NSString *const requestApproved;
extern NSString *const requestDenied;
extern NSString *const possibleOldRequest;
extern NSString *const requestHidden;

@interface AuthRequestViewController : UIViewController

@property (nonatomic, copy) successBlock thisSuccess;
@property (nonatomic, copy) failureBlock thisFailure;
@property (nonatomic, copy) completion completionBlock;

-(id)initWithParentView:(UIViewController*)parentViewController;
-(void)showRequest:(UIViewController*)parentViewController withSucess:(successBlock)success withFailure:(failureBlock)failure __attribute((deprecated("Use -checkForPendingAuthRequest:withCompletion:")));
-(void)checkForPendingAuthRequest:(UIViewController*)parentViewController withCompletion:(completion)completion;

@end