//
//  ViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/8/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSString *status;
    NSArray *tableItems;
}

@end

@implementation ViewController

@synthesize tblFeatures;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableItems = [NSArray arrayWithObjects:@"Linking (Default Manual)", @"Linking (Default Scanner)", @"Linking (Custom Manual)", @"Security", @"Security Information", @"Logout", @"Unlink", @"Unlink Remote Device", @"Check For Requests", @"Authorizations (Default UI)", @"Authorizations (Custom UI)", @"Devices (Default UI)", @"Devices (Custom UI)", @"Logs (Default UI)", @"Logs (Custom UI)", @"OTP", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkActiveSession) name:activeSessionComplete object:nil];
    
    [self refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refreshView];
}

-(void)refreshView
{
    if([[WhiteLabelManager sharedClient] isAccountActive])
        status = @"Linked";
    else
        status = @"Unlinked";
    
    //Navigation Bar Title
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.text = [NSString stringWithFormat:@"WhiteLabel Demo App (%@)", status];
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
}

#pragma mark - NSNotification Observer Methods
-(void)checkActiveSession
{
    // This will be called checkActiveSessions has completed
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"FeatureCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Set Cell Tags
    UILabel *labelFeatureName = (UILabel*)[cell viewWithTag:101];
    labelFeatureName.text = [tableItems objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        // Linking (Default Manual)
        
        if(![[WhiteLabelManager sharedClient] isAccountActive])
        {
            [[WhiteLabelManager sharedClient] showLinkingView:self withCamera:NO withLinked:^{
                
                [self refreshView];
                
            } withFailure:^(NSString *errorMessage, NSString *errorCode) {
                
                NSLog(@"%@, %@", errorMessage, errorCode);
                
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 1)
    {
        // Linking (Default Scanner)
        
        if(![[WhiteLabelManager sharedClient] isAccountActive])
        {
            [[WhiteLabelManager sharedClient] showLinkingView:self withCamera:YES withLinked:^{
                
                [self refreshView];
                
            } withFailure:^(NSString *errorMessage, NSString *errorCode) {
                
                NSLog(@"%@, %@", errorMessage, errorCode);
                
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 2)
    {
        // Linking (Custom Manual)
        
        if(![[WhiteLabelManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toLinkingCustomViewController" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 3)
    {
        //Security
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [[WhiteLabelManager sharedClient] showSecurityView:self withUnLinked:^{
                
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        
    }
    else if(indexPath.row == 4)
    {
        //Security Information
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            NSArray *securityFactorArray = [[WhiteLabelManager sharedClient] getSecurityInfo];
            NSString *enabledFactor = @"";
            
            for(int i = 0; i < [securityFactorArray count]; i++)
            {
                NSDictionary *dict = [securityFactorArray objectAtIndex:i];
                
                if(i == [securityFactorArray count] - 1)
                    enabledFactor = [enabledFactor stringByAppendingString:[NSString stringWithFormat:@"Factor: %@ \n Type: %@ \n Active: %@", [dict objectForKey:@"factor"], [dict objectForKey:@"type"], [dict objectForKey:@"active"]]];
                else
                    enabledFactor = [enabledFactor stringByAppendingString:[NSString stringWithFormat:@"Factor: %@ \n Type: %@ \n Active: %@ \n\n", [dict objectForKey:@"factor"], [dict objectForKey:@"type"], [dict objectForKey:@"active"]]];
            }
            
            if([enabledFactor isEqualToString:@""])
            {
                enabledFactor = @"There are no set factors";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Set Factors:"]
                                                            message:enabledFactor
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 5)
    {
        //Log Out
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            if([[WhiteLabelManager sharedClient] checkActiveSessions])
            {
                [[WhiteLabelManager sharedClient] logOut:self withSuccess:^{
                    
                    [self refreshView];
                    
                } withFailure:^(NSString *errorMessage, NSString *errorCode) {
                    
                    NSLog(@"%@, %@", errorMessage, errorCode);
                    
                }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"No active sessions"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 6)
    {
        //Unlink
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [[WhiteLabelManager sharedClient] unlinkDevice:self withSuccess:^{
                
                [self refreshView];
                
            } withFailure:^(NSString *errorMessage, NSString *errorCode) {
                
                NSLog(@"%@, %@", errorMessage, errorCode);
                
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 7)
    {
        //Unlink Remote Device
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Unlink Device:"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 1;
            
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 8)
    {
        //Check for Requests
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toContainerViewController" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 9)
    {
        //Authorizations (Default UI)
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toAuthorizationDefaultViewController" sender:self];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 10)
    {
        //Authorizations (Custom UI)
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toAuthorizationCustomViewController" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 11)
    {
        //Devices (Default UI)
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toDevicesDefaultViewController" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 12)
    {
        //Devices (Custom UI)
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toDevicesCustomViewController" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 13)
    {
        //Logs (Default UI)
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toLogsDefaultViewController" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 14)
    {
        //Logs (Custom UI)
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toLogsCustomViewController" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(indexPath.row == 15)
    {
        //OTP
        
        if([[WhiteLabelManager sharedClient] isAccountActive])
        {
            [[WhiteLabelManager sharedClient] showTokensView:self withUnLinked:^{
                
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
}

#pragma mark - Alertview Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            UITextField *deviceNameTextField = [alertView textFieldAtIndex:0];
            NSString *deviceName = deviceNameTextField.text;
            
            NSLog(@"Device Name Entered: %@", deviceName);
            
            [[WhiteLabelManager sharedClient] unlinkDevice:self withDeviceName:deviceName withSuccess:^{
                
                NSLog(@"%@ has been unlinked", deviceName);
                
                [self refreshView];
                
            } withFailure:^(NSString *errorMessage, NSString *errorCode) {
                
                NSLog(@"%@, %@", errorMessage, errorCode);
                
            }];
        }
    }
}

@end
