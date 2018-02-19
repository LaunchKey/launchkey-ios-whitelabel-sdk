//
//  SessionDefaultViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/15/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "SessionDefaultViewController.h"

@interface SessionDefaultViewController ()
{
    SessionsViewController *authorizationChildView;
}
@end

@implementation SessionDefaultViewController

@synthesize containerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title =  @"Sessions (Default UI)";
    
    authorizationChildView = [[SessionsViewController alloc] initWithParentView:self];
    
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

@end
