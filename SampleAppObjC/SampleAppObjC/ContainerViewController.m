//
//  ContainerViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Navigation Bar Buttons
    UIBarButtonItem *rightItemRefresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavRefresh"] style:UIBarButtonItemStyleDone target:self action:@selector(btnRefreshPressedNav:)];
    [rightItemRefresh setAccessibilityIdentifier:@"checkForRequests_refresh"];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItemRefresh, nil]];

    self.navigationItem.title =  @"Auth Request View";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[AuthRequestManager sharedManager] checkForPendingAuthRequest:self.navigationController withCompletion:^(NSString *message, NSError *error)
         {
             if(error != nil)
             {
                 NSLog(@"Error: %@", error);
                 if(error.code == 401)
                     [self deviceUnlinked];
                 
                 if([error.localizedFailureReason isEqualToString:@"Authorization already has response!"])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Authorization already has a response"]
                                                                     message:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     
                     [alert show];
                 }
             }
             else
                 NSLog(@"Message: %@", message);
         }];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requestApproved object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requestDenied object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestApproved) name:requestApproved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDenied) name:requestDenied object:nil];
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

-(void)deviceUnlinked
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
}

-(void)requestReceived
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[AuthRequestManager sharedManager] checkForPendingAuthRequest:self.navigationController withCompletion:^(NSString *message, NSError *error)
         {
             if(error != nil)
             {
                 NSLog(@"Error: %@", error);
                 
                 if([error.localizedFailureReason isEqualToString:@"Authorization already has response!"])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Authorization already has a response"]
                                                                     message:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     
                     [alert show];
                 }
             }
             else
                 NSLog(@"Message: %@", message);
         }];
    });
}

#pragma mark - Menu Methods
-(void)btnRefreshPressedNav:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[AuthRequestManager sharedManager] checkForPendingAuthRequest:self.navigationController withCompletion:^(NSString *message, NSError *error)
         {
             if(error != nil)
             {
                 NSLog(@"Error: %@", error);
                 
                 if([error.localizedFailureReason isEqualToString:@"Authorization already has response!"])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Authorization already has a response"]
                                                                     message:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     
                     [alert show];
                 }
             }
             else
                 NSLog(@"Message: %@", message);
         }];
    });
}

@end
