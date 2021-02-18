//
//  PairQRViewController.h
//  WhiteLabel
//
//  Created by ani on 4/12/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AuthenticatorManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AuthenticatorButton.h"
#import "IOATextField.h"

@interface PairQRViewController : UIViewController <UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewQR;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewManualEntry;
@property (weak, nonatomic) IBOutlet IOATextField *tfQREntry;
@property (weak, nonatomic) IBOutlet AuthenticatorButton *btnTapToFinish;
@property BOOL inCameraMode;

- (void)displayLinkingViewWithCamera:(BOOL)camera withSDKKey:(NSString*)sdkKey;
@end
