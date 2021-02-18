//
//  AuthResponseFailureViewController.m
//  Authenticator
//
//  Created by ani on 12/1/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import "AuthResponseFailureViewController.h"
#import "AuthResponseInitialViewController.h"
#import "AuthenticatorManager.h"
#import "AuthenticatorButton.h"
#import "LaunchKeyUIBundle.h"

@interface AuthResponseFailureViewController ()
{
    int numberOfPushedViews;
}

@property (weak, nonatomic) IBOutlet UIView *viewRequestInfo;
@property (weak, nonatomic) IBOutlet UIView *viewFailureReason;
@property (weak, nonatomic) IBOutlet UILabel *authRequestTitle;
@property (weak, nonatomic) IBOutlet UITextView *requestDetailsTextView;
@property (weak, nonatomic) IBOutlet AuthenticatorButton *btnDismiss;
@property (weak, nonatomic) IBOutlet UILabel *labelFailureTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelFailureDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDetailsBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDetailsTop;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewRequestDetails;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleToBottom;
@property (weak, nonatomic) IBOutlet UILabel *labelRequestDetailsHeader;

@end

@implementation AuthResponseFailureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:nil];
    
    numberOfPushedViews = _viewCalledFrom + 1;
    
    // Set Colors
    _viewRequestInfo.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authContentViewBackgroundColor;
    _viewFailureReason.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authContentViewBackgroundColor;
 
    // Set Labels And Colors
    self.navigationItem.title = _request.title;
    _authRequestTitle.text = _request.title;
    _authRequestTitle.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;

    if(![_request.context isKindOfClass:[NSNull class]])
        _requestDetailsTextView.text = _request.context;
    
    _labelFailureTitle.text = _failureTitle;
    _labelFailureTitle.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseFailedColor;
    _labelFailureDescription.text = _failureReason;
    _labelFailureDescription.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
    _labelRequestDetailsHeader.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
    _requestDetailsTextView.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
    
    // Remove left padding for details text view
    _requestDetailsTextView.textContainerInset = UIEdgeInsetsZero;
    _requestDetailsTextView.textContainer.lineFragmentPadding = 0;
}

-(void)viewWillLayoutSubviews
{
    if([_request.context isKindOfClass:[NSNull class]])
    {
        _labelRequestDetailsHeader.hidden = YES;
        _requestDetailsTextView.hidden = YES;
        _stackViewRequestDetails.hidden = YES;
        _constraintDetailsTop.constant = 0;
        _constraintDetailsBottom = 0;
        _constraintTitleToBottom.priority = 999;
    }
}

- (IBAction)btnDismissPressed:(id)sender
{
    [self popViewControllers:numberOfPushedViews];
}

-(void)popViewControllers:(int)viewsToPop
{
    if((int)self.navigationController.viewControllers.count > viewsToPop)
    {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - viewsToPop - 1 ];
        [self.navigationController popToViewController:vc animated:NO];
    }
}

@end
