//
//  AuthResponseFinalViewController.m
//  Authenticator
//
//  Created by ani on 11/14/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import "AuthResponseFinalViewController.h"
#import "LKUIConstants.h"
#import "AuthenticatorManager.h"
#import "LaunchKeyUIBundle.h"

@interface AuthResponseFinalViewController ()
{
    int numberOfPushedViews;
}

@property (weak, nonatomic) IBOutlet UIView *outterViewFinal;
@property (weak, nonatomic) IBOutlet UIImageView *imageFinal;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@end

@implementation AuthResponseFinalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:nil];
    
    self.navigationItem.title = _appName;
    
    numberOfPushedViews = _viewCalledFrom + 1;
    
    // Set up UI for View
    NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
    NSString *imageName = nil;
    
    if(_isSuccessful)
    {
        _outterViewFinal.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseAuthorizedColor;
         imageName = @"ic_done_48pt";
        [_imageFinal setAccessibilityLabel:NSLocalizedString(@"Authorization Approved",@"voice over for authorization approved")];
    }
    else
    {
        _outterViewFinal.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authResponseDeniedColor;
        imageName = @"baseline_close_black_48pt";
        [_imageFinal setAccessibilityLabel:NSLocalizedString(@"Authorization Denied",@"voice over for authorization denied")];
    }
        
    UIImage *centerImage = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    [centerImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_imageFinal setImage:centerImage];
    _imageFinal.tintColor = [UIColor whiteColor];
    
    // Convert outter view to circle
    _outterViewFinal.layer.cornerRadius = _outterViewFinal.bounds.size.width/2;
    _outterViewFinal.layer.masksToBounds = YES;
    
    // Set View Content Background Color
    _viewContent.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authContentViewBackgroundColor;
    
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, _imageFinal);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self popViewControllers:numberOfPushedViews];
    });
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
