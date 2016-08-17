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
    DevicesViewController *devicesView;
    NSMutableArray *devicesArray;
    NSIndexPath *selectedIndexPath;
    
    NSString *remoteDeviceName;
}

@end

@implementation DevicesCustomViewController

@synthesize tblDevices;

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
    lbNavTitle.text = @"Devices (Custom UI)";
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
    
    devicesView = [[DevicesViewController alloc] initWithParentView:self];
    
    NSString *currentDeviceName = [devicesView getCurrentDevice];
    NSLog(@"current device name = %@", currentDeviceName);
    
    [devicesView getDeviceList:^(NSMutableArray* array, NSError *error)
     {
         if(error)
             NSLog(@"Oops error: %@", error.localizedDescription);
         else
         {
             devicesArray = array;
             for(int i = 0; i < [devicesArray count]; i++)
             {
                 NSDictionary *dict = [devicesArray objectAtIndex:i];
                 
                 for(id key in dict)
                     NSLog(@"key: %@, value: %@", key, [dict objectForKey:key]);
             }
             
             [tblDevices reloadData];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Menu Methods
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [btnUnlink addTarget:self action:@selector(btnUnlinkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dict = [devicesArray objectAtIndex:indexPath.row];
    NSString *deviceName = [dict objectForKey:@"deviceName"];
    NSString *status = [dict objectForKey:@"status"];
    
    if(indexPath.row != 0)
        labelCurrentDevice.hidden = YES;
    
    labelDeviceName.text = deviceName;
    
    //pending link
    if ([status intValue] == statusLinking)
    {
        labelStatus.text = @"Linking";
    }
    //pending unlink
    else  if ([status intValue] == statusUnlinking)
    {
        labelStatus.text = @"Unlinking";
    }
    //normal
    else
    {
        labelStatus.text = @"Linked";
    }
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
        NSDictionary *aDict = [devicesArray objectAtIndex:selectedIndexPath.row];
        remoteDeviceName = [aDict objectForKey:@"deviceName"];
        
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
            [[WhiteLabelManager sharedClient] unlinkDevice:self withSuccess:^{
                
            } withFailure:^(NSString *errorMessage, NSString *errorCode) {
                
                NSLog(@"%@, %@", errorMessage, errorCode);
                
            }];
        }
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            [[WhiteLabelManager sharedClient] unlinkDevice:self withDeviceName:remoteDeviceName withSuccess:^{
                
                devicesView = [[DevicesViewController alloc] initWithParentView:self];
                
                [devicesView getDeviceList:^(NSMutableArray* array, NSError *error)
                 {
                 }];
            } withFailure:^(NSString *errorMessage, NSString *errorCode) {
                
                NSLog(@"%@, %@", errorMessage, errorCode);
                
            }];
        }
    }
}


@end
