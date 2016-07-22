//
//  DevicesDefaultViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/15/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "DevicesDefaultViewController.h"

@interface DevicesDefaultViewController ()
{
    DevicesViewController *devicesChildView;
}
@end

@implementation DevicesDefaultViewController

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
    lbNavTitle.text = @"Devices (Default UI)";
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
    
    devicesChildView = [[DevicesViewController alloc] initWithParentView:self];
    
    [self addChildViewController:devicesChildView];
    [self.containerView addSubview:devicesChildView.view];
    [devicesChildView didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Menu Methods
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
