//
//  ContainerViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
{
    AuthRequestViewController *authRequestChildView;
}
@end

@implementation ContainerViewController

@synthesize containerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    authRequestChildView = [[AuthRequestViewController alloc] initWithParentView:self];
    
    [self addChildViewController:authRequestChildView];
    [self.containerView addSubview:authRequestChildView.view];
    [authRequestChildView didMoveToParentViewController:self];
    
    //Navigation Bar Buttons
    UIBarButtonItem *rightItemRefresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavRefresh"] style:UIBarButtonItemStyleDone target:self action:@selector(btnRefreshPressedNav:)];
    
    rightItemRefresh.tintColor = [UIColor colorWithRed:(61.0/255.0) green:(160.0/255.0) blue:(183.0/255.0) alpha:1.0];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItemRefresh, nil]];

    self.navigationItem.title =  @"Auth Request View";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [authRequestChildView checkForPendingAuthRequest:self.navigationController withCompletion:^(NSString *message, NSError *error)
         {
             if(error != nil)
             {
                 NSLog(@"Error: %@", error);
                 if(error.code == 401)
                     [self deviceUnlinked];
             }
             else
             {
                 NSLog(@"Message: %@", message);
             }
         }];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requestApproved object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requestDenied object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requestHidden object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestApproved) name:requestApproved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDenied) name:requestDenied object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestHidden) name:requestHidden object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceUnlinked) name:deviceUnlinked object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestReceived) name:requestReceived object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:deviceUnlinked object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requestReceived object:nil];
}

-(void)requestApproved
{
    // This will be called when an auth request has been approved... Add any custom UI here
}

-(void)requestDenied
{
    // This will be called when an auth request has been denied... Add any custom UI here
}

-(void)requestHidden
{
    // This will be called when an auth request has been hidden after setting up additional security factors from the auth request flow
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self btnRefreshPressedNav:self];
    });
}

-(void)deviceUnlinked
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
}

-(void)requestReceived
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [authRequestChildView checkForPendingAuthRequest:self.navigationController withCompletion:^(NSString *message, NSError *error)
         {
             if(error != nil)
             {
                 NSLog(@"Error: %@", error);
             }
             else
             {
                 NSLog(@"Message: %@", message);
             }
         }];
    });
}

#pragma mark - Menu Methods
-(void)btnRefreshPressedNav:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [authRequestChildView checkForPendingAuthRequest:self.navigationController withCompletion:^(NSString *message, NSError *error)
         {
             if(error != nil)
             {
                 NSLog(@"Error: %@", error);
             }
             else
             {
                 NSLog(@"Message: %@", message);
             }
         }];
    });
}

@end
