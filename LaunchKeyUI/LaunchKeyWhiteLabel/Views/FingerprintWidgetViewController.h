//
//  FingerprintWidgetViewController.h
//  LaunchKey
//
//  Created by ani on 12/22/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticatorButton.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@class FingerprintWidgetViewController;

@protocol FingerprintWidgetDelegate <NSObject>

-(void)FingerprintVerified:(FingerprintWidgetViewController *)controller FingerprintVerified:(BOOL)FingerprintValid withAuthReason:(AuthResponseReason)reason;

@end

@interface FingerprintWidgetViewController : UIViewController

@property (nonatomic,weak) id <FingerprintWidgetDelegate> delegate;
@property (weak, nonatomic) LKCAuthRequestDetails* authRequestDetails;
@property (weak, nonatomic) IBOutlet AuthenticatorButton *btnStartScan;

@end
