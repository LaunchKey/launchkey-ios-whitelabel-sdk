//
//  LogsDefaultViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/15/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "LogsDefaultViewController.h"

@interface LogsDefaultViewController ()
{
    LogsViewController *logsChildView;
}

@end

@implementation LogsDefaultViewController

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
    lbNavTitle.text = @"Logs (Default UI)";
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
    
    logsChildView = [[LogsViewController alloc] initWithParentView:self];
    
    [self addChildViewController:logsChildView];
    [self.containerView addSubview:logsChildView.view];
    [logsChildView didMoveToParentViewController:self];
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
