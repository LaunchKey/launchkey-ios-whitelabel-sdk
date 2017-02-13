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
    
    self.navigationItem.title =  @"Devices (Default UI)";
    
    devicesChildView = [[DevicesViewController alloc] initWithParentView:self];
    
    [self addChildViewController:devicesChildView];
    [self.containerView addSubview:devicesChildView.view];
    [devicesChildView didMoveToParentViewController:self];
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
        [self.navigationController popViewControllerAnimated:NO];
    });
}

@end
