//
//  PINCodeViewController.h
//  LaunchKey
//
//  Created by ani on 12/2/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinCodeButton.h"
#import "LKUIStringVerification.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@class PINCodeViewController;

@protocol PINCodeViewControllerDelegate <NSObject>

-(void)updatePinCode:(PINCodeViewController *)controller updateString:(NSMutableString *)PINString;

-(void)updateLabel:(PINCodeViewController *)controller updateString:(NSString *)labelMessage;

-(void)PINVerified:(PINCodeViewController *)controller PINIsVerified:(BOOL)validPIN;

@end


@interface PINCodeViewController : UIViewController

@property (nonatomic,weak) id <PINCodeViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinOne;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinTwo;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinThree;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinFour;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinFive;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinSix;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinSeven;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinEight;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinNine;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnPinZero;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *imgDelete;
@property (weak, nonatomic) IBOutlet PinCodeButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *imgDone;
@property (weak, nonatomic) IBOutlet UILabel *labelPINDots;
@property (weak, nonatomic) IBOutlet UILabel *labelABC;
@property (weak, nonatomic) IBOutlet UILabel *labelDEF;
@property (weak, nonatomic) IBOutlet UILabel *labelGHI;
@property (weak, nonatomic) IBOutlet UILabel *labelJKL;
@property (weak, nonatomic) IBOutlet UILabel *labelMNO;
@property (weak, nonatomic) IBOutlet UILabel *labelPQRS;
@property (weak, nonatomic) IBOutlet UILabel *labelTUV;
@property (weak, nonatomic) IBOutlet UILabel *labelWXYZ;

-(void)setDoneButtonEnabled:(BOOL)enabled;

@property AuthMethodWidgetState state;
@property (weak, nonatomic) LKCAuthRequestDetails* authRequestDetails;
@property (nonatomic, strong) NSMutableString *stringPINCode;
@property BOOL creation, verifying, removing;
@property BOOL validPin;
@property BOOL verifyAlways;

@end
