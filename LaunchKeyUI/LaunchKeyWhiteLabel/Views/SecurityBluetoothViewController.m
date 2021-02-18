//
//  SecurityBluetoothViewController.m
//  LaunchKey
//
//  Created by ani on 12/15/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "SecurityBluetoothViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewController.h"
#import "SecurityViewController.h"
#import "LKUIConstants.h"
#import "SecurityFactorTableViewCell.h"
#import "IOALabel.h"
#import "AuthenticatorManager.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCWearablesManager.h>
#import <LKCAuthenticator/LKCWearable.h>

@interface SecurityBluetoothViewController ()
{
    NSMutableArray *devicesArray;
    UIRefreshControl *refreshControl;
    IOALabel *labelNoFactorsFound;
}

@end

@implementation SecurityBluetoothViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshPressed:)];
    
    UIButton *rightHelpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [rightHelpButton addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightHelp = [[UIBarButtonItem alloc] initWithCustomView:rightHelpButton];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightRefresh, rightHelp, nil]];
    else
        self.navigationItem.rightBarButtonItem = rightRefresh;
    
    self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"bluetooth_add", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(btnRefreshPressed:) forControlEvents:UIControlEventValueChanged];
    [_tblDevices addSubview:refreshControl];
    
    [self setUpNoWearablesLabel];
    
    [self getConnectedWearables];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setUpNoWearablesLabel
{
    if(self.navigationController.navigationBar.translucent && IS_IPHONE_X)
        labelNoFactorsFound = [[IOALabel alloc] initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height / 2 - [UIApplication sharedApplication].statusBarFrame.size.height, self.navigationController.view.frame.size.width, 20)];
    else if(self.navigationController.navigationBar.translucent && !IS_IPHONE_X)
        labelNoFactorsFound = [[IOALabel alloc] initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height / 2, self.navigationController.view.frame.size.width, 20)];
    else if(!self.navigationController.navigationBar.translucent && IS_IPHONE_X)
        labelNoFactorsFound = [[IOALabel alloc] initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height / 2 - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height, self.navigationController.view.frame.size.width, 20)];
    else
        labelNoFactorsFound = [[IOALabel alloc] initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height / 2 - self.navigationController.navigationBar.frame.size.height, self.navigationController.view.frame.size.width, 20)];
    
    labelNoFactorsFound.text = NSLocalizedStringFromTableInBundle(@"Bluetooth_No_Bluetooth_Devices_Found", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
        [labelNoFactorsFound setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:16]];
    [labelNoFactorsFound setFont:[UIFont systemFontOfSize:14]];
    labelNoFactorsFound.textAlignment = NSTextAlignmentCenter;
    labelNoFactorsFound.textColor = [IOALabel appearance].textColor;
}

#pragma mark - Get Connected Wearables
-(void)getConnectedWearables
{
    [LKCWearablesManager getAvailableWearablesWithCompletion:^(NSArray *connectedWearables, NSString *error) {
       if(error == nil)
       {
           [labelNoFactorsFound removeFromSuperview];
           devicesArray = [connectedWearables copy];
           [_tblDevices  reloadData];
           [self->refreshControl endRefreshing];
       }
        else
        {
            _tblDevices.hidden = YES;
            [self.view addSubview:labelNoFactorsFound];
            if([error isEqualToString:NSLocalizedStringFromTableInBundle(@"Device_Factor_Not_Support", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)] || [error isEqualToString:NSLocalizedStringFromTableInBundle(@"Device_Factor_Not_Authorize", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)] || [error isEqualToString:NSLocalizedStringFromTableInBundle(@"Bluetooth_Off", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)] ) {
                [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Warning", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error];
            }
            [self->refreshControl endRefreshing];
        }
    }];
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [devicesArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"BluetoothCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Set Cell Tags
    UILabel *labelSecurityFactorName = (UILabel*)[cell viewWithTag:1];
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:2];
    
    // Set Colors
    labelSecurityFactorName.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
        [labelSecurityFactorName setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:14]];

    LKCWearable *wearable = [devicesArray objectAtIndex:indexPath.item];
    labelSecurityFactorName.text = wearable.name;
    
    if([SecurityFactorTableViewCell appearance].imageWearablesFactor != nil)
        [imgView setImage:[SecurityFactorTableViewCell appearance].imageWearablesFactor];
    else
    {
        NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
        UIImage *image = [UIImage imageNamed:@"ic_bluetooth" inBundle:bundle compatibleWithTraitCollection:nil];

        [imgView setImage:image];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKCWearable *wearable = [devicesArray objectAtIndex:indexPath.item];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"Device_Factor_Name_Device", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *btnOkay = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   UITextField *tfDeviceName = alert.textFields[0];
                                   [tfDeviceName resignFirstResponder];
                                   NSString *deviceName = tfDeviceName.text;
                                   
                                   NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
                                   
                                   if (deviceName == NULL || [deviceName isEqualToString:@""] || ([[deviceName stringByTrimmingCharactersInSet: set] length] == 0))
                                   {
                                       [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Bluetooth_Name_Missing_Error_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Bluetooth_Name", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                                       return;
                                   }
                                   else if (deviceName.length < methodNameMinimum)
                                   {
                                       [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Bluetooth_Name_Invalid_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Warning_Four_Characters_Bluetooth", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                                       return;
                                   }
        
                                    // Set Device Name
                                    wearable.name = deviceName;
        
                                    [LKCWearablesManager addWearable:wearable withCompletion:^(NSError *error) {
                                        if([error.localizedFailureReason isEqualToString:@"The Wearable object provided has already been added"])
                                        {
                                            [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Wait", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Device_Factor_Already_Added", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                                            return;
                                        }
                                    }];
                                        
                                    [self showInformationAlert:NSLocalizedStringFromTableInBundle(@"Device_Factor_Added", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                                        
                                    //show verified for a bit
                                    double delayInSeconds = 1.0;
                                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                        if(_fromAdd)
                                            [self.delegate bluetoothAdded:self];
                                        [self.navigationController popViewControllerAnimated:NO];
                                    });
                               }];
    
    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * action)
                              {
                              }];
    
    [alert addAction:btnOkay];
    [alert addAction:btnCancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.text = wearable.name;
         textField.accessibilityLabel = @"bluetooth_text_field";
         textField.accessibilityIdentifier = @"setname_edit_name";
     }];
    [self presentViewController:alert animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Alert Methods
-(void)showInformationAlert:(NSString*)message
{
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:nil
           message:message
    preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:toast animated:YES completion:nil];
    int duration = 2.5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - Button Methods
- (IBAction)btnRefreshPressed:(id)sender
{
    [self getConnectedWearables];
}

-(void)helpPressed:(id)sender
{
    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"About_Bluetooth_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"help_security_add_bt", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
}

#pragma mark - Show Alert
-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message
{
    if(UIAccessibilityIsVoiceOverRunning())
    {
        title = @"";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
