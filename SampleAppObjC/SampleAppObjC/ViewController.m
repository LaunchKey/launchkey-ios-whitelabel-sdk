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
    
    tableItems = [NSArray arrayWithObjects:@"Linking (Default Manual)", @"Linking (Default Scanner)", @"Linking (Custom Manual)", @"Auth Methods", @"Unlink", @"Check For Requests", @"Log Out", @"Sessions (Default UI)", @"Sessions (Custom UI)", @"Devices (Default UI)", @"Devices (Custom UI)", @"Config Testing", @"Push Package Testing", nil];
    
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
    if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
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
        
        if(![[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

                [[AuthenticatorManager sharedClient] showLinkingView:self.navigationController withSDKKey:[defaults objectForKey:@"sdkKey"] withCamera:NO withCompletion:^(NSError *error) {
                    if (error) {
                        NSLog(@"%@", error);
                    }
                    [self refreshView];
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
        
        if(![[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

            [[AuthenticatorManager sharedClient] showLinkingView:self.navigationController withSDKKey:[defaults objectForKey:@"sdkKey"] withCamera:YES withCompletion:^(NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                }
                [self refreshView];
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
        
        if(![[LKCAuthenticatorManager sharedClient] isDeviceLinked])
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

        if([[LKCAuthenticatorManager sharedClient] isDeviceLinked] || [[LKCAuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableSecurityChangesWhenUnlinked)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[AuthenticatorManager sharedClient] showSecurityViewWithNavController:self.navigationController];
                
            });
        }
        else
            [self showDeviceNotLinkedError];

    }
    else if(indexPath.row == 4)
    {
        //Unlink
        
        if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            [[LKCAuthenticatorManager sharedClient] unlinkDevice:nil withCompletion:^(NSError *error){
               
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
    else if(indexPath.row == 5)
    {
        //Check for Requests
        
        if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            [self performSegueWithIdentifier:@"toContainerViewController" sender:self];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 6)
    {
        // Log out
        if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            // End All Sessions
            [[LKCAuthenticatorManager sharedClient] endAllSessions:^(NSError *error)
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
    else if(indexPath.row == 7)
    {
        //Sessions (Default UI)
        
        if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            [self performSegueWithIdentifier:@"toSessionDefaultViewController" sender:self];

        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 8)
    {
        //Sessions (Custom UI)
        
        if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            [self performSegueWithIdentifier:@"toSessionCustomViewController" sender:self];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 9)
    {
        //Devices (Default UI)
        
        if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            [self performSegueWithIdentifier:@"toDevicesDefaultViewController" sender:self];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 10)
    {
        //Devices (Custom UI)
        
        if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        {
            [self performSegueWithIdentifier:@"toDevicesCustomViewController" sender:self];
        }
        else
            [self showDeviceNotLinkedError];
    }
    else if(indexPath.row == 11)
    {
        // Config Testing
        [self performSegueWithIdentifier:@"toConfigTestingViewController" sender:self];
    }
    else if(indexPath.row == 12)
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
