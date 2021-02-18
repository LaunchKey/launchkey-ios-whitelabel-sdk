//
//  AuthResponseDenialContextViewController.m
//  Authenticator
//
//  Created by ani on 11/14/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import "AuthResponseDenialContextViewController.h"
#import "LKUIConstants.h"
#import "AuthResponseFinalViewController.h"
#import "ExpirationTimerView.h"
#import "AuthResponseFailureViewController.h"
#import "AuthenticatorManager.h"
#import "AuthResponseNegativeButton.h"
#import "LaunchKeyUIBundle.h"

@interface AuthResponseDenialContextViewController () <UITableViewDelegate, UITableViewDataSource,AuthResponseFailureViewControllerDelegate>
{
    NSArray *denialReasons;
    NSString *denialReasonID;
    BOOL isFraud;
    NSIndexPath* lastSelected;
    NSTimer *timer;
    CGFloat progressTime;
    CGFloat progressPercentage;
    UIImpactFeedbackGenerator *feedbackGenerator;
    int numberOfPushedViews;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableDenialReasons;
@property (weak, nonatomic) IBOutlet UIView *viewSubmitAndTimer;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet ExpirationTimerView *expirationTimer;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labelPressAndHoldTo;
@property (weak, nonatomic) IBOutlet UILabel *labelFinish;

@end

@implementation AuthResponseDenialContextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:nil];
    
    self.navigationItem.title = _request.title;
    numberOfPushedViews = _viewCalledFrom + 1;
    
    denialReasonID = nil;
    lastSelected = nil;
    
    denialReasons = _request.denialReasons;
    
    _tableDenialReasons.rowHeight = UITableViewAutomaticDimension;
    _tableDenialReasons.estimatedRowHeight = 80.0;
    _tableDenialReasons.alwaysBounceVertical = NO;

    // Set Up View Background Colors
    _viewSubmitAndTimer.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authContentViewBackgroundColor;
    _tableDenialReasons.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authContentViewBackgroundColor;
    _tableDenialReasons.separatorColor = [UIColor clearColor];
    
    // Set Button
    [self setUpButton];
    
    // Set Progress Bar
    _progressView.tintColor = ([AuthResponseNegativeButton appearance].fillColor != nil) ? [AuthResponseNegativeButton appearance].fillColor : defaultAuthResponseNegativeFillColor;
    _progressView.trackTintColor = ([AuthResponseNegativeButton appearance].backgroundColor != nil) ? [AuthResponseNegativeButton appearance].backgroundColor : defaultAuthResponseNegativeButtonBackgroundColor;
    _progressView.layer.cornerRadius = 10;
    _progressView.clipsToBounds = YES;
    _progressView.hidden = YES;

    // Listen to timer expired event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExpiredRequest) name:@"TimerExpired" object:nil];
    
    [[self btnSubmit] setAccessibilityLabel:NSLocalizedString(@"Press and hold to finish",@"voice over for Press and hold to finish")];
}

-(void)setUpButton
{
    // Set Up Submit Button
    _btnSubmit.backgroundColor = ([AuthResponseNegativeButton appearance].backgroundColor != nil) ? [AuthResponseNegativeButton appearance].backgroundColor : defaultAuthResponseNegativeButtonBackgroundColor;
    _btnSubmit.layer.cornerRadius = 10;
    _btnSubmit.clipsToBounds = YES;
    _btnSubmit.enabled = NO;
    _btnSubmit.alpha = 0.5;
    [_btnSubmit setExclusiveTouch:YES];
    
    _labelPressAndHoldTo.textColor = ([AuthResponseNegativeButton appearance].textColor != nil) ? [AuthResponseNegativeButton appearance].textColor : [UIColor whiteColor];
    _labelFinish.textColor = ([AuthResponseNegativeButton appearance].textColor != nil) ? [AuthResponseNegativeButton appearance].textColor : [UIColor whiteColor];
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

#pragma mark - Calculate Expiration Timer Duration
- (int)calculateExpirationTimerDuration
{
    NSString *expiresAt = _request.expiresAtTime;
    NSString *createdAt = _request.createdAtTime;
    
    int timeDifference = [expiresAt intValue] - [createdAt intValue];
    
    return timeDifference;
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return denialReasons.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 105;
    else
        return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellHeaderIdentifier = @"HeaderCell";
    static NSString *cellDenialReasonIdentifier = @"DenialReasonCell";
    
    if(indexPath.row == 0)
    {
        UITableViewCell *cellHeader = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
        if (cellHeader == nil)
        {
            cellHeader = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:cellHeaderIdentifier];
            
            cellHeader.accessoryType = UITableViewCellAccessoryNone;
            cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *labelWhyAreYouDenying = (UILabel*)[cellHeader viewWithTag:1];
        UILabel *labelChooseBestOption = (UILabel*)[cellHeader viewWithTag:2];
        labelWhyAreYouDenying.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
        labelChooseBestOption.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
        cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;

        return cellHeader;
    }

    else
    {
        UITableViewCell *cellDenialReason = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellDenialReasonIdentifier];
        if (cellDenialReason == nil)
        {
            cellDenialReason = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:cellDenialReasonIdentifier];
            
            cellDenialReason.accessoryType = UITableViewCellAccessoryNone;
            cellDenialReason.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        // Set Denial Reason Label
        UILabel *labelDenialReason = (UILabel*)[cellDenialReason viewWithTag:2];
        labelDenialReason.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonUnselectedColor;
        
        // Set Selector View
        UIView *viewSelector = (UIView*)[cellDenialReason viewWithTag:3];
        viewSelector.backgroundColor = [UIColor clearColor];
        viewSelector.layer.cornerRadius = viewSelector.bounds.size.width/2;
        viewSelector.layer.masksToBounds = YES;
        viewSelector.layer.borderColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonUnselectedColor.CGColor;
        viewSelector.layer.borderWidth = 1.0f;
        
        if(indexPath == lastSelected)
        {
            [cellDenialReason setSelected:TRUE animated:TRUE];
            labelDenialReason.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonSelectedColor;
            viewSelector.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonSelectedColor;
            viewSelector.layer.borderColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonSelectedColor.CGColor;
        }
        
        if(indexPath.row >= 1)
        {
            labelDenialReason.text = [[denialReasons objectAtIndex:indexPath.row - 1] valueForKey:@"reason"];
        }
        
        cellDenialReason.selectionStyle = UITableViewCellSelectionStyleNone;

        return cellDenialReason;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return;
    
    if (lastSelected == indexPath)
        return;
    
    UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:lastSelected];
    UILabel *lastLabelDenialReason = (UILabel*)[lastSelectedCell viewWithTag:2];
    lastLabelDenialReason.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonUnselectedColor;
    UIView *lastViewSelector = (UIView*)[lastSelectedCell viewWithTag:3];
    lastViewSelector.backgroundColor = [UIColor clearColor];
    lastViewSelector.layer.cornerRadius = lastViewSelector.bounds.size.width/2;
    lastViewSelector.layer.masksToBounds = YES;
    lastViewSelector.layer.borderColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonUnselectedColor.CGColor;
    lastViewSelector.layer.borderWidth = 1.0f;
    [lastSelectedCell setSelected:FALSE animated:TRUE];
    
    // Select New
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *labelDenialReason = (UILabel*)[cell viewWithTag:2];
    labelDenialReason.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonSelectedColor;
    UIView *viewSelector = (UIView*)[cell viewWithTag:3];
    viewSelector.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonSelectedColor;
    viewSelector.layer.cornerRadius = viewSelector.bounds.size.width/2;
    viewSelector.layer.masksToBounds = YES;
    viewSelector.layer.borderColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDenialReasonSelectedColor.CGColor;
    [cell setSelected:TRUE animated:TRUE];

    // Keep Track of the Last Selected Cell
    lastSelected = indexPath;
    
    // Set Denial Reason ID and Fraud Flag
    denialReasonID = [[denialReasons objectAtIndex:indexPath.row - 1] valueForKey:@"id"];
    isFraud = [[[denialReasons objectAtIndex:indexPath.row - 1] valueForKey:@"fraud"] boolValue];
    
    // Enable Submit Button
    _progressView.hidden = NO;
    _btnSubmit.enabled = YES;
    _btnSubmit.alpha = 1.0;
    _btnSubmit.backgroundColor = [UIColor clearColor];

    // Deselect Row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Methods
- (IBAction)btnSubmitTouchUpInside:(id)sender
{
    if(progressTime < durationForProgress)
        [_progressView setProgress:0.00];
    
    [timer invalidate];
}

- (IBAction)btnSubmitTouchDown:(id)sender
{
    timer = [NSTimer scheduledTimerWithTimeInterval:progressIncrement target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    progressTime = 0;
}

- (IBAction)btnSubmitDragExit:(id)sender
{
    [timer invalidate];
    [_progressView setProgress:0.00];
}

#pragma mark - Submit Request
-(void)submitRequest
{
    [_expirationTimer invalidateTimer];
    
    if(isFraud)
        [self sendResponseWithAuthenticated:false type:DENIED reason:FRAUDULENT denialReason:denialReasonID];
    else
        [self sendResponseWithAuthenticated:false type:DENIED reason:DISAPPROVED denialReason:denialReasonID];
}

#pragma mark - Send Response
-(void)sendResponseWithAuthenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString *)denialReason
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
    
    [self.authResponseDenyDelegate respondToRequestFromDenial:self authenticated:authenticated type:type reason:reason denialReason:denialReason withCompletion:^(NSError *error)
     {
         if(!error)
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
         else
         {
             // The API call was unsuccessful
             // Dismiss View
             [self popViewControllers:numberOfPushedViews];
         }
         
         // Remove Spinner + Dimmed View
         [spinner stopAnimating];
         [dimView removeFromSuperview];
     }];
}

#pragma mark - Timer Fired
-(void)timerFired
{
    progressTime = progressTime + progressIncrement;
    progressPercentage = progressTime / durationForProgress * _btnSubmit.frame.size.width / 100;
    [_progressView setProgress:progressPercentage];
    
    if(progressTime >= durationForProgress)
    {
        // Add Haptic Feedback
        feedbackGenerator = [[UIImpactFeedbackGenerator alloc] init];
        [feedbackGenerator prepare];
        [feedbackGenerator impactOccurred];
        [feedbackGenerator prepare];
        
        // Deny
        [self submitRequest];
        
        [timer invalidate];
    }
}

#pragma mark - Handle Expired Request
-(void)handleExpiredRequest
{
    [_expirationTimer invalidateTimer];
    
    // Go to Failure View
    AuthResponseFailureViewController *vcFailView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthResponseFailureViewController"];
    vcFailView.request = _request;
    vcFailView.viewCalledFrom = numberOfPushedViews;
    vcFailView.failureTitle = NSLocalizedStringFromTableInBundle(@"Failed_Request_Expired", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    vcFailView.failureReason = NSLocalizedStringFromTableInBundle(@"Failed_Request_Expired_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    vcFailView.authResponseFailureDelegate = self;
    [self.navigationController pushViewController:vcFailView animated:NO];
}

#pragma mark - Pop View Controllers
-(void)popViewControllers:(NSUInteger)viewsToPop
{
    if(self.navigationController.viewControllers.count > viewsToPop)
    {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - viewsToPop - 1 ];
        [self.navigationController popToViewController:vc animated:NO];
    }
}

@end
