//
//  DevicesViewController.m
//  WhiteLabel
//
//  Created by ani on 5/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "DevicesViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LKUIConstants.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "DevicesTableViewCell.h"
#import "AuthenticatorManager.h"
#import <LKCAuthenticator/LKCAuthenticatorManager.h>
#import "LaunchKeyUIBundle.h"

@interface DevicesViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIRefreshControl *refreshControl;
    NSIndexPath *selectedIndexPath;
    UIViewController* __weak _launcherParentViewController;
    
    LKCDevice *deviceToUnlink;
    
    //JWE *jweObject;
}

@property (weak, nonatomic) IBOutlet UITableView *tblDevices;
@property NSMutableArray *devicesTableDataSource;
@property NSString *thisDeviceName;
@property NSString *remoteDeviceName;

@end

@implementation DevicesViewController

@synthesize devicesTableDataSource, thisDeviceName;

- (id)initWithParentView:(UIViewController*)parentViewController
{
    _launcherParentViewController = parentViewController;

    NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
    
    self = [super initWithNibName:@"DevicesViewController" bundle:bundle];
    
    if (self)
    {
        NSString *deviceName = [[LKCAuthenticatorManager sharedClient] currentDevice].name;
        NSString *trimmedString = [deviceName stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        thisDeviceName = trimmedString;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    devicesTableDataSource = [[NSMutableArray alloc] init];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tblDevices addSubview:refreshControl];
    
    NSString *deviceName = [[LKCAuthenticatorManager sharedClient] currentDevice].name;
    NSString *trimmedString = [deviceName stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    thisDeviceName = trimmedString;
        
    [self getDevices];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    if ([_tblDevices respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tblDevices setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tblDevices respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tblDevices setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Get Devices
- (void)getDevices
{
    [[LKCAuthenticatorManager sharedClient] getDevices:^(NSArray<LKCDevice*> *array, NSError *error) {
        if (error) {
            [refreshControl endRefreshing];
            
            NSString *deviceName = [[LKCAuthenticatorManager sharedClient] currentDevice].name;
            NSString *trimmedString = [deviceName stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceCharacterSet]];
            thisDeviceName = trimmedString;
            
            if([error code] != 401)
            {
                //pre-populate with this device
                devicesTableDataSource = [[NSMutableArray alloc] init];
                
                LKCDevice *deviceObject = [LKCDevice new];
                if(thisDeviceName != nil)
                    deviceObject.name = thisDeviceName;
                
                [devicesTableDataSource addObject:deviceObject];
                
                [_tblDevices reloadData];
            }
        }
        // Success
        else {
            devicesTableDataSource = [NSMutableArray arrayWithArray:array];
            [_tblDevices reloadData];
            _tblDevices.scrollEnabled = YES;
            _tblDevices.hidden = NO;
            [refreshControl endRefreshing];
        }
    }];
}

#pragma mark - Get Current Device
-(LKCDevice*)currentDevice
{
    return [[LKCAuthenticatorManager sharedClient] currentDevice];
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [devicesTableDataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"DevicesCell";
    NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
    
    [tableView registerNib:[UINib nibWithNibName:@"DevicesTableViewCell" bundle:bundle] forCellReuseIdentifier:MyIdentifier];
    
    DevicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.btnUnlink addTarget:self action:@selector(btnUnlinkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    LKCDevice *deviceObject = [devicesTableDataSource objectAtIndex:indexPath.row];
        
    [cell.btnUnlink setTitle:NSLocalizedStringFromTableInBundle(@"devices_buttons_status_active", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];
    
    cell.labelCurrentDevice.hidden = (indexPath.row == 0) ? NO : YES;
    
    cell.labelDeviceName.text = deviceObject.name;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
    {
        [cell.labelDeviceName setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:17]];
        cell.btnUnlink.titleLabel.font = [UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:14];
        [cell.labelCurrentDevice setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:15]];
    }
    
    [cell.btnUnlink setTitleColor:[AuthenticatorButton appearance].negativeActionTextColor forState:UIControlStateNormal];
    [cell.btnUnlink setBackgroundColor:[AuthenticatorButton appearance].negativeActionBackgroundColor];
    
    return cell;
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:_tblDevices];
    return [_tblDevices indexPathForRowAtPoint:buttonFrame.origin];
}

#pragma mark - Buttons Methods
-(void)btnUnlinkPressed:(id)sender
{
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    selectedIndexPath = indexPath;

    if(indexPath.row == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"devices_alert_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btnUnlink = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"devices_alert_button", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       [[LKCAuthenticatorManager sharedClient] unlinkDevice:nil withCompletion:^(NSError *error){
                                       }];
                                   }];
        UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                          }];
        
        [alert addAction:btnUnlink];
        [alert addAction:btnCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        deviceToUnlink = [devicesTableDataSource objectAtIndex:indexPath.row];
        _remoteDeviceName = deviceToUnlink.name;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"devices_alert_title_other", @"Localizable", [NSBundle LaunchKeyUIBundle],nil), _remoteDeviceName]
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btnUnlink = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"devices_alert_button", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [[LKCAuthenticatorManager sharedClient] unlinkDevice:deviceToUnlink withCompletion:^(NSError *error){
                                            if(error == nil)
                                                [self getDevices];
                                        }];
                                    }];
        UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                          }];
        
        [alert addAction:btnUnlink];
        [alert addAction:btnCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Refresh Control
-(void)handleRefresh:(id)sender
{
    [self getDevices];
}
#pragma mark - Refresh Devices
-(void)refreshDevicesView
{
    [self getDevices];
}

@end
