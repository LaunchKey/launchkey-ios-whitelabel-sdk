//
//  AuthResponseInitialViewController.m
//  Authenticator
//
//  Created by ani on 11/14/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import "AuthResponseInitialViewController.h"
#import "AuthenticatorManager.h"
#import "LKUIConstants.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "ExpirationTimerView.h"
#import "AuthResponseViewController.h"
#import "AuthResponseDenialContextViewController.h"
#import "AuthResponseFinalViewController.h"
#import "AuthResponseFailureViewController.h"
#import "AuthResponseButton.h"
#import "AuthResponseNegativeButton.h"
#import "LaunchKeyUIBundle.h"
#import "LKUIStringVerification.h"

@interface AuthResponseInitialViewController () <AuthResponseViewControllerDelegate, AuthResponseDenialContextViewControllerDelegate, AuthResponseFailureViewControllerDelegate>
{
    LKCAuthRequestDetails *request;
    NSArray *authMethods;
    NSTimer *timer;
    CGFloat progressTime;
    CGFloat progressPercentage;
    UIImpactFeedbackGenerator *feedbackGenerator;
    BOOL checkPIN, checkCircle, checkWearable, checkGeo, checkLocations, checkFingerprint;
    BOOL authFailed;
    NSString *quickFailReason;
    int numberOfMethods;
}

@property (weak, nonatomic) IBOutlet UILabel *authRequestTitle;
@property (weak, nonatomic) IBOutlet UITextView *requestDetailsTextView;
@property (weak, nonatomic) IBOutlet UIButton *authResponseDeny;
@property (weak, nonatomic) IBOutlet UIButton *authResponseAuthorize;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressViewAuthorize;
@property (strong, nonatomic) IBOutlet ExpirationTimerView *expirationTimer;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewRequestDetails;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopExpirationToStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopExpirationToTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopDetailsToTitle;
@property (weak, nonatomic) IBOutlet UIView *viewAuthContent;
@property (weak, nonatomic) IBOutlet UILabel *labelRequestDetailsHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelExpiresInHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelYourResponseHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelPressAndHoldTo1;
@property (weak, nonatomic) IBOutlet UILabel *labelPressAndHoldTo2;
@property (weak, nonatomic) IBOutlet UILabel *labelDeny;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthorize;

@end

@implementation AuthResponseInitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:nil];

    // Set Up Content View Background Color
    _viewAuthContent.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authContentViewBackgroundColor;
    
    // Set Labels And Colors
    self.navigationItem.title = request.title;
    _authRequestTitle.text = request.title;
    _authRequestTitle.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
    _requestDetailsTextView.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
    _labelRequestDetailsHeader.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
    _labelExpiresInHeader.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
    _labelYourResponseHeader.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
    if(![request.context isKindOfClass:[NSNull class]]) {
        _requestDetailsTextView.text = request.context;
        _requestDetailsTextView.accessibilityLabel = request.context;
    }
    _labelExpiresInHeader.accessibilityElementsHidden = YES;
    _labelYourResponseHeader.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"Your_Response_Label_Accessibility", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    // Set Progress Bars
    _progressView.tintColor = ([AuthResponseNegativeButton appearance].fillColor != nil) ? [AuthResponseNegativeButton appearance].fillColor : defaultAuthResponseNegativeFillColor;
    _progressView.trackTintColor = ([AuthResponseNegativeButton appearance].backgroundColor != nil) ? [AuthResponseNegativeButton appearance].backgroundColor : defaultAuthResponseNegativeButtonBackgroundColor;
    _progressView.layer.cornerRadius = 10;
    _progressView.clipsToBounds = YES;
    _progressViewAuthorize.tintColor = ([AuthResponseButton appearance].fillColor != nil) ? [AuthResponseButton appearance].fillColor : defaultAuthResponseFillColor;
    _progressViewAuthorize.trackTintColor = ([AuthResponseButton appearance].backgroundColor != nil) ? [AuthResponseButton appearance].backgroundColor : defaultAuthResponseButtonBackgroundColor;
    _progressViewAuthorize.layer.cornerRadius = 10;
    _progressViewAuthorize.clipsToBounds = YES;
    
    // Set Up Buttons
    [self setUpButtons];
    
    // Remove left padding for details text view
    _requestDetailsTextView.textContainerInset = UIEdgeInsetsZero;
    _requestDetailsTextView.textContainer.lineFragmentPadding = 0;
    
    // Listen to timer expired event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExpiredRequest) name:@"TimerExpired" object:nil];
    
    [[self authResponseAuthorize] setAccessibilityLabel:NSLocalizedString(@"Press and hold to authorize",@"voice over for Press and hold to authorize")];
    [[self authResponseDeny] setAccessibilityLabel:NSLocalizedString(@"Press and hold to deny",@"voice over for Press and hold to deny")];
}

-(void)setUpButtons
{
    // Set Deny Button
    _authResponseDeny.backgroundColor = [UIColor clearColor];
    _authResponseDeny.layer.cornerRadius = 10;
    _authResponseDeny.clipsToBounds = YES;
    [_authResponseDeny setExclusiveTouch:YES];
    
    // Set Authorize Button
    _authResponseAuthorize.backgroundColor = [UIColor clearColor];
    [_authResponseAuthorize setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _authResponseAuthorize.layer.cornerRadius = 10;
    _authResponseAuthorize.clipsToBounds = YES;
    [_authResponseAuthorize setExclusiveTouch:YES];

    _labelPressAndHoldTo1.textColor = ([AuthResponseNegativeButton appearance].textColor != nil) ? [AuthResponseNegativeButton appearance].textColor : [UIColor whiteColor];
    _labelDeny.textColor = ([AuthResponseNegativeButton appearance].textColor != nil) ? [AuthResponseNegativeButton appearance].textColor : [UIColor whiteColor];

    _labelPressAndHoldTo2.textColor = ([AuthResponseButton appearance].textColor != nil) ? [AuthResponseButton appearance].textColor : [UIColor whiteColor];
    _labelAuthorize.textColor = ([AuthResponseButton appearance].textColor != nil) ? [AuthResponseButton appearance].textColor : [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews
{
    // Set Up Expiration Timer
    _expirationTimer.expirationDuration = [self calculateExpirationTimerDuration];
    _expirationTimer.isBigTimer = YES;
    _expirationTimer.backgroundColor = [UIColor clearColor];
    _expirationTimer.expiresAt = request.expiresAtTime;
    
    // Set Up Constrtaints
    if([request.context isKindOfClass:[NSNull class]])
    {
        _labelRequestDetailsHeader.hidden = YES;
        _requestDetailsTextView.hidden = YES;
        _stackViewRequestDetails.hidden = YES;
        _constraintTopExpirationToStackView.constant = 0;
        _constraintTopDetailsToTitle.constant = 0;
        _constraintTopExpirationToTitle.constant = 20;
        _constraintTopExpirationToTitle.priority = 999;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimerExpired" object:nil];
}

#pragma mark - Calculate Expiration Timer Duration
- (int)calculateExpirationTimerDuration
{
    NSString *expiresAt = request.expiresAtTime;
    NSString *createdAt = request.createdAtTime;
    
    int timeDifference = [expiresAt intValue] - [createdAt intValue];
    
    return timeDifference;
}

#pragma mark - Display Auth Response View With Auth Request
-(void)displayAuthResponseWithAuthRequestDetails:(LKCAuthRequestDetails*)authRequestDetails withRequiredAuthMethodArray:(NSArray*)authMethodsArray withNumOfMethods:(int)num withQuickFail:(BOOL)quickFail withQuickFailReason:(NSString*)reason
{
    request = authRequestDetails;
    authMethods = authMethodsArray;
    authFailed = quickFail;
    numberOfMethods = num;
    quickFailReason = reason;
    
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

- (IBAction)btnAuthorizeTouchDown:(id)sender
{
    timer = [NSTimer scheduledTimerWithTimeInterval:progressIncrement target:self selector:@selector(timerFiredForAuth) userInfo:nil repeats:YES];
    progressTime = 0;
}

- (IBAction)btnAuthorizeTouchUpInside:(id)sender
{
    if(progressTime < durationForProgress)
        [_progressViewAuthorize setProgress:0.00];
    
    [timer invalidate];
}

- (IBAction)btnAuthorizeDragExit:(id)sender
{
    [timer invalidate];
    [_progressViewAuthorize setProgress:0.00];
}

#pragma mark - Set Up Auth Methods
- (void)setUpAuthMethods
{
    checkPIN = [[authMethods objectAtIndex:0] boolValue];
    checkCircle = [[authMethods objectAtIndex:1] boolValue];
    checkWearable = [[authMethods objectAtIndex:2] boolValue];
    checkGeo = [[authMethods objectAtIndex:3] boolValue];
    checkLocations = [[authMethods objectAtIndex:4] boolValue];
    checkFingerprint = [[authMethods objectAtIndex:5] boolValue];
}

#pragma mark - Deny Auth Request
- (void)denyAuthRequest
{
    [_expirationTimer invalidateTimer];
    
    // Check for denial reasons
    if(![request.denialReasons isKindOfClass:[NSNull class]])
    {
        // Go to Denial Context View
        AuthResponseDenialContextViewController *vcDenyView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseDenialContextViewController"];
        vcDenyView.request = request;
        vcDenyView.viewCalledFrom = 1;
        vcDenyView.authResponseDenyDelegate = self;
        [self.navigationController pushViewController:vcDenyView animated:NO];
    }
    else
    {
        // Respond w/ Deny
        [self sendResponseWithAuthenticated:false type:DENIED reason:DISAPPROVED denialReason:nil failureTitle:nil failureReason:nil];
    }
}

#pragma mark - Authorize Auth Request
-(void)authorizeAuthRequest
{
    [_expirationTimer invalidateTimer];
    
    if(authFailed)
    {
        // Auth Request Fails
        [self handleFailedRequest];
    }
    else
    {
        if(authMethods != nil && numberOfMethods > 0)
        {
            // Set Up Auth Methods To Be Checked
            [self setUpAuthMethods];
            
            // Go to Auth Response View
            AuthResponseViewController *vcAuthView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseViewController"];
            vcAuthView.authMethods = authMethods;
            vcAuthView.request = request;
            vcAuthView.checkPIN = checkPIN;
            vcAuthView.checkCircle = checkCircle;
            vcAuthView.checkWearable = checkWearable;
            vcAuthView.checkGeo = checkGeo;
            vcAuthView.checkLocations = checkLocations;
            vcAuthView.checkFingerprint = checkFingerprint;
            vcAuthView.numberOfMethods = numberOfMethods;
            vcAuthView.viewCalledFrom = 1;
            vcAuthView.authResponseDelegate = self;
            [self.navigationController pushViewController:vcAuthView animated:NO];
        }
        else
        {
            [self sendResponseWithAuthenticated:true type:AUTHORIZED reason:APPROVED denialReason:nil failureTitle:nil failureReason:nil];
        }
    }
}

#pragma mark - Timer Fired Methods
- (void)timerFired
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

- (void)timerFiredForAuth
{
    progressTime = progressTime + progressIncrement;
    progressPercentage = progressTime / durationForProgress * _authResponseAuthorize.frame.size.width / 100;
    [_progressViewAuthorize setProgress:progressPercentage];
    
    if(progressTime >= durationForProgress)
    {
        // Add Haptic Feedback
        feedbackGenerator = [[UIImpactFeedbackGenerator alloc] init];
        [feedbackGenerator prepare];
        [feedbackGenerator impactOccurred];
        [feedbackGenerator prepare];
        
        // Authorize
        [self authorizeAuthRequest];
        
        [timer invalidate];
    }
}

#pragma mark - Responsd To Request
- (void)respondToRequest:(AuthResponseViewController *)controller authenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString *)denialReason withCompletion:(authResponseComplete)completion
{
    [self.authResponseInitialDelegate respondToRequest:self authenticated:authenticated type:type reason:reason denialReason:denialReason withCompletion:^(NSError *error)
     {
         if(completion != nil)
             completion(error);
     }];
}

- (void)respondToRequestFromDenial:(AuthResponseDenialContextViewController *)controller authenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString *)denialReason withCompletion:(authResponseComplete)completion
{
    [self.authResponseInitialDelegate respondToRequest:self authenticated:authenticated type:type reason:reason denialReason:denialReason withCompletion:^(NSError *error)
     {
         if(completion != nil)
             completion(error);
     }];
}

#pragma mark - Handle Expired Request
- (void)handleExpiredRequest
{
    [_expirationTimer invalidateTimer];
    
    // Go to Failure View
    AuthResponseFailureViewController *vcFailView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseFailureViewController"];
    vcFailView.request = request;
    vcFailView.viewCalledFrom = 1;
    vcFailView.failureTitle = NSLocalizedStringFromTableInBundle(@"Failed_Request_Expired", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    vcFailView.failureReason = NSLocalizedStringFromTableInBundle(@"Failed_Request_Expired_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    vcFailView.authResponseFailureDelegate = self;
    [self.navigationController pushViewController:vcFailView animated:NO];
}

#pragma mark - Handle Failed Request
-(void)handleFailedRequest
{
    // Go to Failure View
    AuthResponseReason reason;
    NSString *failureTitle = nil;
    
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

    [self.authResponseInitialDelegate respondToRequest:self authenticated:authenticated type:type reason:reason denialReason:denialReason withCompletion:^(NSError *error)
     {
         if(!error)
         {
             // The API call was successful
             if(type == FAILED)
             {
                 // Go to Failure View
                 AuthResponseFailureViewController *vcFailView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseFailureViewController"];
                 vcFailView.failureReason = failureReason;
                 vcFailView.failureTitle = failureTitle;
                 vcFailView.numberOfMethods = [[authMethods objectAtIndex:2] intValue];
                 vcFailView.authResponseFailureDelegate = self;
                 vcFailView.request = request;
                 vcFailView.viewCalledFrom = 1;
                 [self.navigationController pushViewController:vcFailView animated:NO];

             }
             else
             {
                 // Go to final Auth Response View
                 AuthResponseFinalViewController *vcFinalView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseFinalViewController"];
                 vcFinalView.isSuccessful = authenticated;
                 vcFinalView.viewCalledFrom = 1;
                 vcFinalView.appName = request.title;
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
             [self.navigationController popViewControllerAnimated:NO];
         }
         
         // Remove Spinner + Dimmed View
         [spinner stopAnimating];
         [dimView removeFromSuperview];
     }];
}

@end
