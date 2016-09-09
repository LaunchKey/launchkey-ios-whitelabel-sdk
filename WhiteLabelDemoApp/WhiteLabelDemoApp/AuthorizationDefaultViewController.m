//
//  AuthorizationDefaultViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/15/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "AuthorizationDefaultViewController.h"

@interface AuthorizationDefaultViewController ()
{
    AuthorizationViewController *authorizationChildView;
}
@end

@implementation AuthorizationDefaultViewController

@synthesize containerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Navigation Bar Buttons
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    leftItem.tintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryTextAndIconsColor];
    [[self navigationItem] setLeftBarButtonItem:leftItem];
    
    //Navigation Bar Title
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.text = @"Authorizations (Default UI)";
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
    
    
    authorizationChildView = [[AuthorizationViewController alloc] initWithParentView:self];
    
    [self addChildViewController:authorizationChildView];
    [self.containerView addSubview:authorizationChildView.view];
    [authorizationChildView didMoveToParentViewController:self];

}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceUnlinked) name:deviceUnlinked object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:deviceUnlinked object:nil];
}

-(void)deviceUnlinked
{    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - Menu Methods
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
