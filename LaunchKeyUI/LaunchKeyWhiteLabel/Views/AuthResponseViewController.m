//
//  AuthResponseViewController.m
//  Authenticator
//
//  Created by ani on 11/14/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import "AuthResponseViewController.h"
#import "ExpirationTimerView.h"
#import "LKUIConstants.h"
#import "AuthResponseDenialContextViewController.h"
#import "AuthResponseFinalViewController.h"
#import "ContainerRequestViewController.h"
#import "AuthenticatorManager.h"
#import "AuthResponseFailureViewController.h"
#import "AuthResponseNegativeButton.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCFaceScanManager.h>
#import "LKUIStringVerification.h"

@interface AuthResponseViewController () <ContainerRequestDelegate, AuthResponseDenialContextViewControllerDelegate, AuthResponseFailureViewControllerDelegate>
{
    NSTimer *timer;
    CGFloat progressTime;
    CGFloat progressPercentage;
    UIImpactFeedbackGenerator *feedbackGenerator;
    int numberOfPushedViews;
    authResponseComplete completionBlock;
    BOOL responseInProgress;
}

@property (weak, nonatomic) IBOutlet UIView *containerAuthMethods;
@property (weak, nonatomic) IBOutlet UILabel *authRequestTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelInstructions;
@property (weak, nonatomic) IBOutlet UIButton *authResponseDeny;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet ExpirationTimerView *expirationTimer;
@property (weak, nonatomic) IBOutlet UIView *viewAuthMethods;
@property (weak, nonatomic) IBOutlet UIView *viewDenialAndTimer;
@property (weak, nonatomic) IBOutlet UILabel *labelPressAndHoldTo;
@property (weak, nonatomic) IBOutlet UILabel *labelDeny;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betweenViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonDenyTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonDenyBottomConstraint;


@end

@implementation AuthResponseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:nil];
    
    // Set Labels and Colors
    self.navigationItem.title = _request.title;
    _authRequestTitle.text = _request.title;
    _authRequestTitle.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;

    numberOfPushedViews = _viewCalledFrom + 1;
    
    responseInProgress = NO;
    
    // Set Progress Bar
    _progressView.tintColor = ([AuthResponseNegativeButton appearance].fillColor != nil) ? [AuthResponseNegativeButton appearance].fillColor : defaultAuthResponseNegativeFillColor;
    _progressView.trackTintColor = ([AuthResponseNegativeButton appearance].backgroundColor != nil) ? [AuthResponseNegativeButton appearance].backgroundColor : defaultAuthResponseNegativeButtonBackgroundColor;
    _progressView.layer.cornerRadius = 10;
    _progressView.clipsToBounds = YES;
    
    // Set Button
    [self setUpButton];
    
    // Set Up Content View Background Color
    _viewAuthMethods.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authContentViewBackgroundColor;
    _viewDenialAndTimer.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authContentViewBackgroundColor;
    
    // Listen to unlink events for all auth methods
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlinkDeviceForPIN) name:kLKUnlinkDevicePINFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlinkDeviceForCircle) name:kLKUnlinkDeviceCircleFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlinkDeviceForWearables) name:kLKUnlinkDeviceWearablesFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlinkDeviceForLocations) name:kLKUnlinkDeviceLocationsFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlinkDeviceForFace) name:kLKUnlinkDeviceFaceFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlinkDeviceForFingerprint) name:kLKUnlinkDeviceFingerprintFailed object:nil];
    // Listen to timer expired event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExpiredRequest) name:@"TimerExpired" object:nil];
   
    [[self authResponseDeny] setAccessibilityLabel:NSLocalizedString(@"Press and hold to deny",@"voice over for Press and hold to deny")];
    
    // Check Device Orientation
    [self checkDeviceOrientation];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

-(void)setUpButton
{
    // Set Deny Button
    _authResponseDeny.backgroundColor = [UIColor clearColor];
    _authResponseDeny.layer.cornerRadius = 10;
    _authResponseDeny.clipsToBounds = YES;
    [_authResponseDeny setExclusiveTouch:YES];
    
    _labelPressAndHoldTo.textColor = ([AuthResponseNegativeButton appearance].textColor != nil) ? [AuthResponseNegativeButton appearance].textColor : [UIColor whiteColor];
    _labelDeny.textColor = ([AuthResponseNegativeButton appearance].textColor != nil) ? [AuthResponseNegativeButton appearance].textColor : [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews
{
    // Set Up Expiration Timer
    _expirationTimer.expirationDuration = [self calculateExpirationTimerDuration];
    _expirationTimer.isBigTimer = NO;
    _expirationTimer.expiresAt = _request.expiresAtTime;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimerExpired" object:nil];
}

-(void)checkDeviceOrientation
{
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[LKUIStringVerification platformString] isEqualToString:@"iPhone SE"] || [[LKUIStringVerification platformString] isEqualToString:@"iPhone 5"] ||  [[LKUIStringVerification platformString] isEqualToString:@"iPhone 5s"])
    {
        [self setLandscapeConstraints];
    }
}

- (void)orientationChanged:(NSNotification *)note
{
   UIDevice * device = note.object;
   switch(device.orientation)
   {
       case UIDeviceOrientationLandscapeLeft:
           [self setLandscapeConstraints];
       break;
       case UIDeviceOrientationLandscapeRight:
           [self setLandscapeConstraints];
       break;
       default:
           if(![[LKUIStringVerification platformString] isEqualToString:@"iPhone SE"] && ![[LKUIStringVerification platformString] isEqualToString:@"iPhone 5"] &&  ![[LKUIStringVerification platformString] isEqualToString:@"iPhone 5s"])
           {
               [self setPortraitConstraints];
           }
           else
           {
               [self setLandscapeConstraints];
           }
       break;
   };
}

-(void)setLandscapeConstraints
{
    _topViewConstraint.constant = 2;
    _betweenViewConstraint.constant = 2;
    _bottomViewConstraint.constant = 2;
    _scrollViewTopConstraint.constant = 2;
    _progressViewTopConstraint.constant = 2;
    _progressViewBottomConstraint.constant = 2;
    _buttonDenyTopConstraint.constant = 2;
    _buttonDenyBottomConstraint.constant = 2;
}

-(void)setPortraitConstraints
{
    _topViewConstraint.constant = 20;
    _betweenViewConstraint.constant = 20;
    _bottomViewConstraint.constant = 20;
    _scrollViewTopConstraint.constant = 20;
     _progressViewTopConstraint.constant = 20;
    _progressViewBottomConstraint.constant = 20;
    _buttonDenyTopConstraint.constant = 20;
    _buttonDenyBottomConstraint.constant = 20;
}

#pragma mark - Calculate Expiration Timer Duration
- (int)calculateExpirationTimerDuration
{
    NSString *expiresAt = _request.expiresAtTime;
    NSString *createdAt = _request.createdAtTime;
    
    int timeDifference = [expiresAt intValue] - [createdAt intValue];
    
    return timeDifference;
}

#pragma mark - Unlink Device
-(void)unlinkDeviceForPIN
{
    [self unlinkDevice:NSLocalizedStringFromTableInBundle(@"Failed_Incorrect_PIN_Code", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withReason:NSLocalizedStringFromTableInBundle(@"Failed_Incorrect_PIN_Code_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forMethod:PINCODE];
}

-(void)unlinkDeviceForCircle
{
    [self unlinkDevice:NSLocalizedStringFromTableInBundle(@"Failed_Incorrect_Circle_Code", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withReason:NSLocalizedStringFromTableInBundle(@"Failed_Incorrect_Circle_Code_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forMethod:CIRCLECODE];
}

-(void)unlinkDeviceForWearables
{
    [self unlinkDevice:NSLocalizedStringFromTableInBundle(@"Failed_Bluetooth_Wearable_Not_Found", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withReason:NSLocalizedStringFromTableInBundle(@"Failed_Bluetooth_Wearable_Not_Found_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forMethod:WEARABLES];
}

-(void)unlinkDeviceForLocations
{
    [self unlinkDevice:NSLocalizedStringFromTableInBundle(@"Failed_Improper_Location", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withReason:NSLocalizedStringFromTableInBundle(@"Failed_Improper_Location_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forMethod:LOCATIONS];
}

-(void)unlinkDeviceForFace
{
    [self unlinkDevice:NSLocalizedStringFromTableInBundle(@"Failed_Face_Not_Recognized", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withReason:NSLocalizedStringFromTableInBundle(@"Failed_Face_Not_Recognized_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forMethod:FACESCAN];
}

-(void)unlinkDeviceForFingerprint
{
    [self unlinkDevice:NSLocalizedStringFromTableInBundle(@"Failed_Figerprint_Not_Recognized", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withReason:NSLocalizedStringFromTableInBundle(@"Failed_Figerprint_Not_Recognized_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forMethod:FINGERPRINTSCAN];
}

-(void)unlinkDevice:(NSString*)failureTitle withReason:(NSString*)failureReason forMethod:(AuthMethodType)authMethod
{
    [self pushFailureViewWithReason:failureTitle withFailureReason:failureReason];
}

#pragma mark - Button Methods
- (IBAction)btnDenyTouchUpInside:(id)sender
{
    if(progressTime < durationForProgress)
        [_progressView setProgress:0.00];
    
    [timer invalidate];
}

- (IBAction)btnDenyTouchDown:(id)sender
{
    timer = [NSTimer scheduledTimerWithTimeInterval:progressIncrement target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    progressTime = 0;
}

- (IBAction)btnDenyDragExit:(id)sender
{
    [timer invalidate];
    [_progressView setProgress:0.00];
}

#pragma mark - Deny Auth Request
-(void)denyAuthRequest
{
    [_expirationTimer invalidateTimer];
    
    if(!responseInProgress)
    {
        // Check for denial reasons
        if(![_request.denialReasons isKindOfClass:[NSNull class]])
        {
            // Go to Denial Context View
            AuthResponseDenialContextViewController *vcDenyView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseDenialContextViewController"];
            vcDenyView.request = _request;
            vcDenyView.viewCalledFrom = numberOfPushedViews;
            vcDenyView.authResponseDenyDelegate = self;
            [self.navigationController pushViewController:vcDenyView animated:NO];
        }
        else
        {
            [self sendResponseWithAuthenticated:false type:DENIED reason:DISAPPROVED denialReason:nil failureTitle:nil failureReason:nil];
            responseInProgress = YES;
        }
    }
}

#pragma mark - Timer Fired
-(void)timerFired
{
    progressTime = progressTime + progressIncrement;
    progressPercentage = progressTime / durationForProgress * _authResponseDeny.frame.size.width / 100;
    [_progressView setProgress:progressPercentage];
    
    if(progressTime >= durationForProgress)
    {
        // Add Haptic Feedback
        feedbackGenerator = [[UIImpactFeedbackGenerator alloc] init];
        [feedbackGenerator prepare];
        [feedbackGenerator impactOccurred];
        [feedbackGenerator prepare];
        
        // Deny
        [self denyAuthRequest];
        
        [timer invalidate];
    }
}

#pragma mark - Deny From Container
-(void)denyRequestFromContainer:(ContainerRequestViewController *)controller withAuthReason:(AuthResponseReason)reason forAuthMethod:(AuthMethodType)authMethod
{
    if(!responseInProgress)
    {
        // Go to Failure View
        if(reason == SENSOR)
        {
            if(authMethod == WEARABLES)
                [self sendResponseWithAuthenticated:false type:FAILED reason:SENSOR denialReason:nil failureTitle:NSLocalizedStringFromTableInBundle(@"Failed_Bluetooth_Disabled", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) failureReason:NSLocalizedStringFromTableInBundle(@"Failed_Bluetooth_Disabled_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            else
                    [self sendResponseWithAuthenticated:false type:FAILED reason:SENSOR denialReason:nil failureTitle:NSLocalizedStringFromTableInBundle(@"Failed_Location_Services_Disabled", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) failureReason:NSLocalizedStringFromTableInBundle(@"Failed_Location_Services_Disabled_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
        }
        else if(reason == PERMISSION)
        {
            if(authMethod == GEOFENCING || authMethod == LOCATIONS)
                [self sendResponseWithAuthenticated:false type:FAILED reason:PERMISSION denialReason:nil failureTitle:NSLocalizedStringFromTableInBundle(@"Failed_Location_Services_Permission", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) failureReason:NSLocalizedStringFromTableInBundle(@"Failed_Location_Services_Permission_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            else if(authMethod == FACESCAN)
                [self sendResponseWithAuthenticated:false type:FAILED reason:PERMISSION denialReason:nil failureTitle:NSLocalizedStringFromTableInBundle(@"Failed_FaceID_Permission_Not_Granted", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) failureReason:NSLocalizedStringFromTableInBundle(@"Failed_FaceID_Permission_Not_Granted_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
        }
        else
        {
            if(authMethod == WEARABLES)
            {
                [self pushFailureViewWithReason:NSLocalizedStringFromTableInBundle(@"Failed_Bluetooth_Wearable_Not_Found", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withFailureReason:NSLocalizedStringFromTableInBundle(@"Failed_Bluetooth_Wearable_Not_Found_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
            else if(authMethod == GEOFENCING || authMethod == LOCATIONS)
            {
                [self pushFailureViewWithReason:NSLocalizedStringFromTableInBundle(@"Failed_Improper_Location", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withFailureReason:NSLocalizedStringFromTableInBundle(@"Failed_Improper_Location_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
            else if(authMethod == FACESCAN)
            {
                [self pushFailureViewWithReason:NSLocalizedStringFromTableInBundle(@"Failed_Face_Not_Recognized", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withFailureReason:NSLocalizedStringFromTableInBundle(@"Failed_Face_Not_Recognized_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
            else if(authMethod == FINGERPRINTSCAN)
            {
                [self pushFailureViewWithReason:NSLocalizedStringFromTableInBundle(@"Failed_Figerprint_Not_Recognized", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withFailureReason:NSLocalizedStringFromTableInBundle(@"Failed_Figerprint_Not_Recognized_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
            else if(authMethod == PINCODE)
            {
                [self pushFailureViewWithReason:NSLocalizedStringFromTableInBundle(@"Failed_Incorrect_PIN_Code", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withFailureReason:NSLocalizedStringFromTableInBundle(@"Failed_Incorrect_PIN_Code_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
            else if(authMethod == CIRCLECODE)
            {
                [self pushFailureViewWithReason:NSLocalizedStringFromTableInBundle(@"Failed_Incorrect_Circle_Code", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withFailureReason:NSLocalizedStringFromTableInBundle(@"Failed_Incorrect_Circle_Code_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
        }

        responseInProgress = YES;
    }
}

#pragma mark - Push Failure View
-(void)pushFailureViewWithReason:(NSString*)reason withFailureReason:(NSString*)failureReason
{
    // Go to Failure View
    AuthResponseFailureViewController *vcFailView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseFailureViewController"];
    vcFailView.request = _request;
    vcFailView.failureTitle = reason;
    vcFailView.failureReason = failureReason;
    vcFailView.authResponseFailureDelegate = self;
    vcFailView.viewCalledFrom = numberOfPushedViews;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [self.navigationController pushViewController:vcFailView animated:NO];
    });
}

#pragma mark - Authorize From Container
-(void)authorizeRequestFromContainer:(ContainerRequestViewController *)sender withToken:(NSString *)token
{
    [_expirationTimer invalidateTimer];
    
    if(!responseInProgress)
    {
        [self sendResponseWithAuthenticated:true type:AUTHORIZED reason:APPROVED denialReason:nil failureTitle:nil failureReason:nil];
        responseInProgress = YES;
    }
}

#pragma mark - Fail From Container
-(void)failRequestFromContainer:(ContainerRequestViewController *)controller withRequest:(NSArray *)authMethods
{
    if(!responseInProgress)
    {
        // Go to Failure View
        AuthResponseReason reason;
        NSString *failureTitle = nil;
        NSString *quickFailReason = [authMethods objectAtIndex:1];
        
        if([quickFailReason isEqualToString:NSLocalizedStringFromTableInBundle(@"Failed_Incompatible_Configuration_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
        {
            failureTitle= NSLocalizedStringFromTableInBundle(@"Failed_Incompatible_Configuration", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            reason = CONFIGURATION;
        }
        else
        {
            if ([quickFailReason hasPrefix:NSLocalizedStringFromTableInBundle(@"Failed_Required_Auth_Method_Not_Enabled_Message_Check", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
            {
                failureTitle = NSLocalizedStringFromTableInBundle(@"Failed_Required_Auth_Method_Not_Enabled", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            }
            else
            {
                failureTitle = NSLocalizedStringFromTableInBundle(@"Failed_Too_Few_Methods", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            }
            reason = POLICY;
        }
        
        [self sendResponseWithAuthenticated:false type:FAILED reason:reason denialReason:nil failureTitle:failureTitle failureReason:quickFailReason];

        responseInProgress = YES;
    }
}

#pragma mark - Update Instruction Label
- (void)updateInstructionLabel:(ContainerRequestViewController *)controller updateLabel:(NSString *)labelMessage updateNumber:(int)numberPresented totalNumber:(int)totalNumberOfFactors
{
    NSString *instructionLabel;
    if([labelMessage isEqualToString:kLKPINCode])
    {
        instructionLabel = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Pin_Code_Step", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), numberPresented, totalNumberOfFactors];
    }
    else if([labelMessage isEqualToString:kLKCircleCode])
    {
        instructionLabel = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Circle_Code_Step", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), numberPresented, totalNumberOfFactors];
    }
    else if([labelMessage isEqualToString:kLKGeofences] || [labelMessage isEqualToString:kLKLocations])
    {
        instructionLabel = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Geofencing_Step", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), numberPresented, totalNumberOfFactors];
    }
    else if([labelMessage isEqualToString:kLKWearables])
    {
        instructionLabel = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Wearable_Step", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), numberPresented, totalNumberOfFactors];
    }
    else if([labelMessage isEqualToString:kLKFingerprintScan])
    {
        if([LKCFaceScanManager isFaceIDAvailable])
        instructionLabel = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Face_Step", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), numberPresented, totalNumberOfFactors];
        else
        instructionLabel = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Fingerprint_Step", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), numberPresented, totalNumberOfFactors];
    }

    _labelInstructions.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;

    NSTimeInterval duration = 1.0f;
    [UIView transitionWithView:_labelInstructions
                      duration:duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _labelInstructions.text = instructionLabel;
    } completion:^(BOOL finished){
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, _labelInstructions);
    }];
}

#pragma mark - Respond To Request Delegate Methods
- (void)respondToRequestFromDenial:(AuthResponseDenialContextViewController *)controller authenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString *)denialReason withCompletion:(authResponseComplete)completion
{
    [self.authResponseDelegate respondToRequest:self authenticated:authenticated type:type reason:reason denialReason:nil withCompletion:^(NSError *error)
     {
         if(completion != nil)
             completion(error);
     }];
}

#pragma mark - Handle Expired Request
-(void)handleExpiredRequest
{
    [_expirationTimer invalidateTimer];
    
    // Go To Failure View
    [self pushFailureViewWithReason:NSLocalizedStringFromTableInBundle(@"Failed_Request_Expired", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withFailureReason:NSLocalizedStringFromTableInBundle(@"Failed_Request_Expired_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
}

#pragma mark - Prepare For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toContainerRequestViewController"])
    {
        ContainerRequestViewController *embed = segue.destinationViewController;
        embed.delegateContainer = self;
        embed.isPINEnabled = _checkPIN;
        embed.isCircleCodeEnabled  = _checkCircle;
        embed.isBluetoothEnabled = _checkWearable;
        embed.isGeofenceEnabled = _checkGeo;
        embed.isLocationsEnabled = _checkLocations;
        embed.isFingerprintEnabled = _checkFingerprint;
        embed.numberOfFactors = _numberOfMethods;
        embed.authRequestDetails = _request;
    }
}

#pragma mark - Send Response
-(void)sendResponseWithAuthenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString *)denialReason failureTitle:(NSString*)failureTitle failureReason:(NSString*)failureReason
{
    // Dim View
    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, self.view.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)];
    dimView.backgroundColor = [[UIApplication sharedApplication].delegate.window.backgroundColor colorWithAlphaComponent:0.7f];
    [self.view addSubview:dimView];
    
    // Add Spinner
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [spinner setColor:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor];
    [dimView addSubview:spinner];
    [spinner startAnimating];
    
    // Disable "Deny" Button since response is being sent to API
    _authResponseDeny.enabled = NO;
    
    [self.authResponseDelegate respondToRequest:self authenticated:authenticated type:type reason:reason denialReason:nil withCompletion:^(NSError *error)
     {
         if(!error)
         {
             // The API call was successful
             if(failureReason != nil)
             {
                 // Go to Failure View
                 [self pushFailureViewWithReason:failureTitle withFailureReason:failureReason];
             }
             else if(denialReason != nil)
             {
                 // Do nothing?
             }
             else
             {
                 // Go to final Auth Response View
                 AuthResponseFinalViewController *vcFinalView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseFinalViewController"];
                 vcFinalView.isSuccessful = authenticated;
                 vcFinalView.viewCalledFrom = numberOfPushedViews;
                 vcFinalView.appName = _request.title;
                 CATransition* transition = [CATransition animation];
                 transition.duration = 0.5;
                 transition.type = kCATransitionFade;
                 [self.navigationController.view.layer addAnimation:transition forKey:nil];
                 [self.navigationController pushViewController:vcFinalView animated:NO];
             }
         }
         else
         {
             // The API call was unsuccessful
             // Dismiss View
             [self popViewControllers:numberOfPushedViews];
         }
         
         // Remove Spinner + Dimmed View
         [spinner stopAnimating];
         [dimView removeFromSuperview];
        
         responseInProgress = NO;
     }];
}

#pragma mark - Pop View Controllers
-(void)popViewControllers:(int)viewsToPop
{
    if((int)self.navigationController.viewControllers.count > viewsToPop)
    {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - viewsToPop - 1 ];
        [self.navigationController popToViewController:vc animated:NO];
    }
}

@end
