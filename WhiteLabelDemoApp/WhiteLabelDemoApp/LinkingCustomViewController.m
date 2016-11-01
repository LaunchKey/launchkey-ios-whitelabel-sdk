//
//  LinkingCustomViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/12/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "LinkingCustomViewController.h"

@interface LinkingCustomViewController ()

@end

@implementation LinkingCustomViewController

@synthesize tfLinkingCode, tfDeviceName, switchDeviceName, btnLink;

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
    lbNavTitle.text = @"Linking View";
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
    
    [switchDeviceName addTarget:self
                         action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    [switchDeviceName setOnTintColor:[[WhiteLabelConfigurator sharedConfig] getSecondaryColor]];
    
    [btnLink setTitleColor:[[WhiteLabelConfigurator sharedConfig] getSecondaryColor]forState:UIControlStateNormal];
}

#pragma mark - Menu Methods
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISwitchDelegateMethods
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        tfDeviceName.enabled = true;
    }
    else
    {
        tfDeviceName.enabled = false;
        [tfDeviceName resignFirstResponder];
    }
}

#pragma mark - Button Methods
- (IBAction)btnLinkPressed:(id)sender
{
    NSString *qrCode = tfLinkingCode.text;
    
    if([qrCode length] == 7)
    {
        if ([switchDeviceName isOn])
        {
            NSString *deviceName = tfDeviceName.text;
            
            if([deviceName length] < 3)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device name should be at least 3 characters"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            }
            else if([deviceName length] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Please enter a device name"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                [[WhiteLabelManager sharedClient] linkUser:qrCode withDeviceName:deviceName withCompletion:^(NSError *error)
                 {
                     if(error != nil)
                     {
                         NSLog(@"error: %@", error);
                     }
                     else
                     {
                         [self back:self];
                     }
                 }];
            }
        }
        else
        {
            [[WhiteLabelManager sharedClient] linkUser:qrCode withDeviceName:nil withCompletion:^(NSError *error)
             {
                 if(error != nil)
                 {
                     NSLog(@"error: %@", error);
                 }
                 else
                 {
                     [self back:self];
                 }
             }];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"QR Code should be 7 characters"]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}


@end
