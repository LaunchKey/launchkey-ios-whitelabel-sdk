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
    BOOL activeSession;
    UIRefreshControl *refreshControl;
    
    DevicesViewController *devicesView;
}

@end

@implementation ViewController

@synthesize tblFeatures;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableItems = [NSArray arrayWithObjects:@"Linking (Default Manual)", @"Linking (Default Scanner)", @"Linking (Custom Manual)", @"Security", @"Security Information", @"Unlink", @"Check For Requests", @"Log Out", @"Sessions (Default UI)", @"Sessions (Custom UI)", @"Devices (Default UI)", @"Devices (Custom UI)", @"Send Metrics", @"Config Testing", @"Push Package Testing", nil];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [tblFeatures addSubview:refreshControl];
    
    [self refreshView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceUnlinked) name:deviceUnlinked object:nil];
    
    [self refreshView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:deviceUnlinked object:nil];
}

-(void)refreshView
{
    if([[AuthenticatorManager sharedClient] isAccountActive])
    {
        status = @"Linked";
    }
    else
    {
        status = @"Unlinked";
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"Sample App Obj C (%@)", status];
}

#pragma mark - Refresh Control
-(void)handleRefresh:(id)sender
{
    [self refreshView];
    
    [refreshControl endRefreshing];
}

#pragma mark - NSNotification Observer Methods
-(void)deviceUnlinked
{
    // This will be called once the device is successfully unlinked or when the API returns an error indicating the device is unlinked
    
    [self refreshView];
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
        
        if(![[AuthenticatorManager sharedClient] isAccountActive])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[AuthenticatorManager sharedClient] showLinkingView:self.navigationController withCamera:NO withLinked:^{
                    
                    [self refreshView];
                    
                } withFailure:^(NSString *errorMessage, NSString *errorCode) {
                    
                    NSLog(@"%@, %@", errorMessage, errorCode);
                    
                }];
            });
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
        
        if(![[AuthenticatorManager sharedClient] isAccountActive])
        {
            [[AuthenticatorManager sharedClient] showLinkingView:self.navigationController withCamera:YES withLinked:^{
                
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
        
        if(![[AuthenticatorManager sharedClient] isAccountActive])
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
        
        self.navigationItem.title = @"";
        
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[AuthenticatorManager sharedClient] showSecurityViewWithNavController:self.navigationController withUnLinked:^{
                    
                }];
                
            });
        }
        else
            [self showDeviceNotLinkedError];

    }
    else if(indexPath.row == 4)
    {
        //Security Information
        
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            NSArray *securityFactorArray = [[AuthenticatorManager sharedClient] getSecurityInfo];
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
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 5)
    {
        //Unlink
        
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            [[AuthenticatorManager sharedClient] unlinkDevice:nil withCompletion:^(NSError *error){
               
                if(error != nil)
                {
                    NSLog(@"Error: %@", error);
                }
                else
                {
                    [self refreshView];
                }
            }];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 6)
    {
        //Check for Requests
        
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toContainerViewController" sender:self];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 7)
    {
        // Log out
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            // End All Sessions
            
            SessionsViewController *sessions = [[SessionsViewController alloc] init];
            [sessions endAllSessions:^(NSError *error)
             {
                 if(error != nil)
                 {
                     NSLog(@"Error: %@", error);
                 }
                 else
                 {
                     [self refreshView];
                 }
             }];
            
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 8)
    {
        //Sessions (Default UI)
        
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toSessionDefaultViewController" sender:self];

        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 9)
    {
        //Sessions (Custom UI)
        
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toSessionCustomViewController" sender:self];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 10)
    {
        //Devices (Default UI)
        
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toDevicesDefaultViewController" sender:self];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 11)
    {
        //Devices (Custom UI)
        
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            [self performSegueWithIdentifier:@"toDevicesCustomViewController" sender:self];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 12)
    {
        if([[AuthenticatorManager sharedClient] isAccountActive])
        {
            // Send Metrics
            [[AuthenticatorManager sharedClient] sendMetricsWithCompletion:^(NSError *error) {
                if(error == nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Metrics successfully sent!"]
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                    });
                }
                else
                    NSLog(@"error: %@", error);
            }];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 13)
    {
        // Config Testing
        [self performSegueWithIdentifier:@"toConfigTestingViewController" sender:self];
    }
    else if(indexPath.row == 14)
    {
        // Push Package Testing
        [self performSegueWithIdentifier:@"toPushPackageTesting" sender:self];
    }
}

#pragma mark - Device Not Linked Error
-(void)showDeviceNotLinkedError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Device is not linked"]
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end
