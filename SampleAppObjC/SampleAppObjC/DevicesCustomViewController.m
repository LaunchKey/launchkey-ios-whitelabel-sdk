//
//  DevicesCustomViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "DevicesCustomViewController.h"

@interface DevicesCustomViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *devicesArray;
    NSIndexPath *selectedIndexPath;
    NSString *remoteDeviceName;
    LKCDevice *deviceToUnlink;
}

@end

@implementation DevicesCustomViewController

@synthesize tblDevices;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Devices (Custom UI)";
    
    LKCDevice *currentDevice = [[LKCAuthenticatorManager sharedClient] currentDevice];
    NSLog(@"current device name = %@", currentDevice.name);
    
    [[LKCAuthenticatorManager sharedClient] getDevices:^(NSArray* array, NSError *error)
     {
         if(error)
             NSLog(@"Oops error: %@", error);
         else
         {
             devicesArray = array;
             
             for(LKCDevice *deviceObject in devicesArray)
             {
                NSLog(@"device name: %@", deviceObject.name);
                NSLog(@"device uuid: %@", deviceObject.UUID);
                NSLog(@"device type: %@", deviceObject.type);
             }
             
             [tblDevices reloadData];
         }
     }];
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

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [devicesArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"DeviceCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    //Set Cell Tags
    UILabel *labelDeviceName = (UILabel*)[cell viewWithTag:1];
    UILabel *labelStatus = (UILabel*)[cell viewWithTag:2];
    UIButton *btnUnlink = (UIButton*)[cell viewWithTag:3];
    UILabel *labelCurrentDevice = (UILabel*)[cell viewWithTag:4];
    UILabel *labelType = (UILabel*)[cell viewWithTag:5];

    [btnUnlink addTarget:self action:@selector(btnUnlinkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    LKCDevice *deviceObject = [devicesArray objectAtIndex:indexPath.row];
    
    NSString *deviceName = deviceObject.name;
    
    if(indexPath.row != 0)
        labelCurrentDevice.hidden = YES;
    
    labelDeviceName.text = deviceName;
    labelType.text = deviceObject.type;
    labelStatus.text = @"Linked";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:tblDevices];
    return [tblDevices indexPathForRowAtPoint:buttonFrame.origin];
}

#pragma mark - Buttons Methods
-(void)btnUnlinkPressed:(id)sender
{
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    selectedIndexPath = indexPath;
    
    if(indexPath.row == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Unlink this device?"]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Unlink", nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
        deviceToUnlink= [devicesArray objectAtIndex:selectedIndexPath.row];
        remoteDeviceName = deviceToUnlink.name;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Unlink %@?", remoteDeviceName]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Unlink", nil];
        alert.tag = 2;
        [alert show];
    }
}

#pragma mark - AlertView Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [[LKCAuthenticatorManager sharedClient] unlinkDevice:nil withCompletion:^(NSError *error)
            {
                if(error != nil)
                {
                    NSLog(@"Error: %@", error);
                }
            }];
        }
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            [[LKCAuthenticatorManager sharedClient] unlinkDevice:deviceToUnlink withCompletion:^(NSError *error)
            {
                if(error != nil)
                {
                    NSLog(@"Error: %@", error);
                }
                else
                {
                    [[LKCAuthenticatorManager sharedClient] getDevices:^(NSArray* array, NSError *error)
                     {
                         devicesArray = array;
                         
                         [tblDevices reloadData];
                     }];
                }
            }];
        }
    }
}

@end
