//
//  BluetoothWidgetViewController.h
//  LaunchKey
//
//  Created by ani on 12/22/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@class BluetoothWidgetViewController;

@protocol BluetoothWidgetDelegate <NSObject>

-(void)BluetoothVerified:(BluetoothWidgetViewController *)controller BluetoothVerified:(BOOL)BluetoothValid withReason:(AuthResponseReason)reason;

@end

@interface BluetoothWidgetViewController : UIViewController

@property (nonatomic,weak) id <BluetoothWidgetDelegate> delegate;
@property (weak, nonatomic) LKCAuthRequestDetails* authRequestDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircle;
@property (weak, nonatomic) IBOutlet UIImageView *imageFactor;


@end
