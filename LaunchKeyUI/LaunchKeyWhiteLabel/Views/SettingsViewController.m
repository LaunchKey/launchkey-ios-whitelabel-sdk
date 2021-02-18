//
//  SettingsViewController.m
//  WhiteLabel
//
//  Created by ani on 4/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "SettingsViewController.h"
#import "SecurityPINCodeViewController.h"
#import "SecurityCircleCodeViewController.h"
#import "SecurityBluetoothViewController.h"
#import "SecurityGeofenceViewController.h"
#import "SecurityFingerprintViewController.h"
#import "AuthenticatorButton.h"
#import "SecurityFactorTableViewCell.h"
#import "AuthenticatorManager.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCFaceScanManager.h>
#import <LKCAuthenticator/LKCFingerprintScanManager.h>
#import <LKCAuthenticator/LKCWearablesManager.h>
#import <LKCAuthenticator/LKCLocationsManager.h>
#import <LKCAuthenticator/LKCCircleCodeManager.h>
#import <LKCAuthenticator/LKCPINCodeManager.h>

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate>
{
    UIRefreshControl *refreshControl;
    NSIndexPath *indexPathSelected;
    BOOL fromVerifySwitch;
    NSString *bundlePath;
    NSBundle *bundle;
    NSArray *locationsArray, *wearablesArray;
}

@end

@implementation SettingsViewController

@synthesize tblFactors;
@synthesize labelRemove, btnRemove, labelVerify, labelChangeEffectiveIn, switchVerify;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bundle = [NSBundle LaunchKeyUIBundle];
    bundlePath = bundle.bundlePath;
}

- (void)viewDidAppear:(BOOL)animated
{
    UIBarButtonItem *rightAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSelected:)];
    rightAdd.accessibilityLabel = @"security_add";
    
    fromVerifySwitch = NO;
    tblFactors.hidden = YES;
        
    switch (_mode) {
        case PINCODE:
        {
            self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"pincode_settings", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            
            break;
        }
        case CIRCLECODE:
        {
            self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"circlecode_settings", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            
            break;
        }
        case WEARABLES:
        {
            self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"bluetooth_settings", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            [[self navigationItem] setRightBarButtonItem:rightAdd];
            refreshControl = [[UIRefreshControl alloc] init];
            [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
            [self.tblFactors addSubview:refreshControl];
            tblFactors.hidden = NO;
            
            [LKCWearablesManager getStoredWearablesWithCompletion:^(NSArray *wearables) {
                wearablesArray = wearables;
                [tblFactors reloadData];
            }];
                        
            break;
        }
        case GEOFENCING:
            break;
        case LOCATIONS:
        {
            self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"geofencing_settings", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            [[self navigationItem] setRightBarButtonItem:rightAdd];
            refreshControl = [[UIRefreshControl alloc] init];
            [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
            [self.tblFactors addSubview:refreshControl];
            tblFactors.hidden = NO;
            
            [LKCLocationsManager getLocationsWithCompletion:^(NSArray *locations) {
                locationsArray = locations;
                [tblFactors reloadData];
            }];
            
            break;
        }
        case FINGERPRINTSCAN:
        {
            if([LKCFingerprintScanManager isTouchIDAvailable])
                self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"fingerprint_settings", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            else
                self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"faceid_settings", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            break;
        }
        case FACESCAN:
        {
            break;
        }
    }
    
    [switchVerify addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    switchVerify.layer.cornerRadius = 16.0;
    [btnRemove addTarget:self action:@selector(btnRemovePressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRemove setAccessibilityIdentifier:@"panel_settings_button_remove"];
    
    tblFactors.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    _headerView.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].controlsBackgroundColor;
    
    // Text Color Configuration
    labelRemove.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    labelVerify.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    labelChangeEffectiveIn.textColor = [[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor colorWithAlphaComponent:0.5];
    
    [self setUpTableHeader];
}

#pragma mark - Set Up Table Header
-(void)setUpTableHeader
{
    labelChangeEffectiveIn.hidden = YES;
    
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
    {
        [labelRemove setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:17]];
        btnRemove.titleLabel.font = [UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:14];
        [labelVerify setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:16]];
        [labelChangeEffectiveIn setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:15]];
    }
    
    switch (_mode) {
        case PINCODE:
        {
            [btnRemove setTitle:NSLocalizedStringFromTableInBundle(@"security_settingspanel_removesingle", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];
            
            if([LKCPINCodeManager getVerificationFlag].state == ALWAYS)
            {
                labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                switchVerify.on = true;
            }
            else
            {
                labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                switchVerify.on = false;
            }
            break;
        }
        case CIRCLECODE:
        {
            [btnRemove setTitle:NSLocalizedStringFromTableInBundle(@"security_settingspanel_removesingle", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];
            
            if([LKCCircleCodeManager getVerificationFlag].state == ALWAYS)
            {
                labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                switchVerify.on = true;
            }
            else
            {
                labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                switchVerify.on = false;
            }
            break;
        }
        case GEOFENCING:
        {
            break;
        }
        case LOCATIONS:
        {
            [btnRemove setTitle:NSLocalizedStringFromTableInBundle(@"security_settingspanel_removeall", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];
            if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
                btnRemove.titleLabel.font = [UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:12];
            
            if(![LKCLocationsManager getVerificationFlag].pendingSwitch)
            {
                labelChangeEffectiveIn.hidden = YES;
                
                if ([LKCLocationsManager getVerificationFlag].state == ALWAYS)
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = true;
                }
                else
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = false;
                }
            }
            else
            {
                labelChangeEffectiveIn.hidden = NO;
                labelChangeEffectiveIn.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_extra_format", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [LKCLocationsManager getVerificationFlag].timeRemainingUntilFlagIsChanged];
                
                if ([LKCLocationsManager getVerificationFlag].state == WHENREQUIRED)
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = true;
                }
                else
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = false;
                }
            }
            break;
        }
        case WEARABLES:
        {
            [btnRemove setTitle:NSLocalizedStringFromTableInBundle(@"security_settingspanel_removeall", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];
            if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
                btnRemove.titleLabel.font = [UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:12];
            
            if(![LKCWearablesManager getVerificationFlag].pendingSwitch)
            {
                labelChangeEffectiveIn.hidden = YES;
                
                if ([LKCWearablesManager getVerificationFlag].state == ALWAYS)
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = true;
                }
                else
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = false;
                }
            }
            else
            {
                labelChangeEffectiveIn.hidden = NO;
                labelChangeEffectiveIn.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_extra_format", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [LKCWearablesManager getVerificationFlag].timeRemainingUntilFlagIsChanged];
                
                if ([LKCWearablesManager getVerificationFlag].state == WHENREQUIRED)
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = true;
                }
                else
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = false;
                }
            }
            break;
        }
        case FINGERPRINTSCAN:
        {
            [btnRemove setTitle:NSLocalizedStringFromTableInBundle(@"security_settingspanel_removesingle", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];
            
            if([LKCFingerprintScanManager getVerificationFlag].state == ALWAYS)
            {
                labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                switchVerify.on = true;
            }
            else
            {
                labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                switchVerify.on = false;
            }
            break;
        }
        case FACESCAN:
        {
            [btnRemove setTitle:NSLocalizedStringFromTableInBundle(@"security_settingspanel_removesingle", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];
            
            if([LKCFaceScanManager getVerificationFlag].state == ALWAYS)
            {
                labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                switchVerify.on = true;
            }
            else
            {
                labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                switchVerify.on = false;
            }
            break;
        }
    }
    
    btnRemove.titleLabel.numberOfLines = 1;
    btnRemove.titleLabel.adjustsFontSizeToFitWidth = YES;
    btnRemove.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    // Set REMOVE Color if negativeActionColor is defined
    [btnRemove setTitleColor:[AuthenticatorButton appearance].negativeActionTextColor forState:UIControlStateNormal];
    [btnRemove setBackgroundColor:[AuthenticatorButton appearance].negativeActionBackgroundColor];
}

#pragma mark - Menu Methods
-(void)addSelected:(id)sender
{
    if(_mode == LOCATIONS)
    {
        SecurityGeofenceViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityGeofenceViewController"];
        vcPushedView.fromSettings = true;
        vcPushedView.fromAdd = false;
        [self.navigationController pushViewController:vcPushedView animated:NO];
    }
    if(_mode == WEARABLES)
    {
        SecurityBluetoothViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityBluetoothViewController"];
        vcPushedView.fromAdd = false;
        [self.navigationController pushViewController:vcPushedView animated:NO];
    }
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_mode == LOCATIONS)
    {
        return [locationsArray count];
    }
    else if(_mode == WEARABLES)
    {
        return [wearablesArray count];
    }
    else
        return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableHeaderViews)
        return CGFLOAT_MIN;
    
    return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeader;
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableHeaderViews)
    {
        if(_mode == WEARABLES)
            sectionHeader = NSLocalizedStringFromTableInBundle(@"Bluetooth_Settings_Table_Header", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        else if(_mode == LOCATIONS)
            sectionHeader = NSLocalizedStringFromTableInBundle(@"Geofence_Settings_Table_Header", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    else
        sectionHeader = nil;
    
    return sectionHeader;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].tableViewHeaderBackgroundColor;
    v.textLabel.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].tableViewHeaderTextColor;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_mode == LOCATIONS)
    {
        static NSString *MyIdentifier = @"GeofenceCell";
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
        UILabel *labelActiveStatus = (UILabel*)[cell viewWithTag:2];
        UIButton *btnDelete = (UIButton*)[cell viewWithTag:3];
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:4];
        
        // Set Colors
        labelSecurityFactorName.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
        labelActiveStatus.textColor = [[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor colorWithAlphaComponent:0.5];
        
        if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
        {
            [labelSecurityFactorName setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:17]];
            [labelActiveStatus setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:14]];
        }
        
        [btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        LKCLocation *location = [locationsArray objectAtIndex:indexPath.row];
        labelSecurityFactorName.text = location.name;
        if(location.timeRemainingUntilRemoved != nil)
        {
            labelActiveStatus.text = [NSString stringWithFormat:@"Removed in %@", location.timeRemainingUntilRemoved];
            
            if([SecurityFactorTableViewCell appearance].imageLocationsFactor != nil)
                [imgView setImage:[SecurityFactorTableViewCell appearance].imageLocationsFactor];
            else
                [imgView setImage:[UIImage imageNamed:@"ic_place" inBundle:bundle compatibleWithTraitCollection:nil]];
            
            UIImage *imageButton = [[UIImage imageNamed:@"ic_undo" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [btnDelete setImage:imageButton forState:UIControlStateNormal];
        }
        else if(location.timeRemainingUntilAdded != nil)
        {
            if(![location.timeRemainingUntilAdded isEqualToString:@"Now"] && ![location.timeRemainingUntilAdded isEqualToString:@"0Y"] && ![location.timeRemainingUntilAdded isEqualToString:@"0yrs"])
            {
                labelActiveStatus.text = [NSString stringWithFormat:@"Active in %@", location.timeRemainingUntilAdded];
            }
            else
            {
                labelActiveStatus.text = @"Active";
            }
            
            if([SecurityFactorTableViewCell appearance].imageLocationsFactor != nil)
                [imgView setImage:[SecurityFactorTableViewCell appearance].imageLocationsFactor];
            else
                [imgView setImage:[UIImage imageNamed:@"ic_place" inBundle:bundle compatibleWithTraitCollection:nil]];
            
            //tint image because inactive
            [imgView setAlpha:0.4];
            
            UIImage *imageButton = [[UIImage imageNamed:@"ic_delete" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [btnDelete setImage:imageButton forState:UIControlStateNormal];
        }
        else
        {
            labelActiveStatus.text = @"Active";
            
            if([SecurityFactorTableViewCell appearance].imageLocationsFactor != nil)
                [imgView setImage:[SecurityFactorTableViewCell appearance].imageLocationsFactor];
            else
                [imgView setImage:[UIImage imageNamed:@"ic_place" inBundle:bundle compatibleWithTraitCollection:nil]];
            
            UIImage *imageButton = [[UIImage imageNamed:@"ic_delete" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [btnDelete setImage:imageButton forState:UIControlStateNormal];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
        UILabel *labelActiveStatus = (UILabel*)[cell viewWithTag:2];
        UIButton *btnDelete = (UIButton*)[cell viewWithTag:3];
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:4];
        
        if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
        {
            [labelSecurityFactorName setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:17]];
            [labelActiveStatus setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:14]];
        }
        
        [btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        LKCWearable *wearable = [wearablesArray objectAtIndex:indexPath.row];
        labelSecurityFactorName.text = wearable.name;
        if(wearable.timeRemainingUntilRemoved != nil)
        {
            labelActiveStatus.text = [NSString stringWithFormat:@"Removed in %@", wearable.timeRemainingUntilRemoved];
            
            if([SecurityFactorTableViewCell appearance].imageWearablesFactor != nil)
                [imgView setImage:[SecurityFactorTableViewCell appearance].imageWearablesFactor];
            else
                [imgView setImage:[UIImage imageNamed:@"ic_bluetooth" inBundle:bundle compatibleWithTraitCollection:nil]];
            
            UIImage *imageButton = [[UIImage imageNamed:@"ic_undo" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [btnDelete setImage:imageButton forState:UIControlStateNormal];

        }
        else if(wearable.timeRemainingUntilAdded != nil)
        {
            if(![wearable.timeRemainingUntilAdded isEqualToString:@"Now"] && ![wearable.timeRemainingUntilAdded isEqualToString:@"0Y"] && ![wearable.timeRemainingUntilAdded isEqualToString:@"0yrs"])
            {
                labelActiveStatus.text = [NSString stringWithFormat:@"Active in %@", wearable.timeRemainingUntilAdded];
            }
            else
            {
                labelActiveStatus.text = @"Active";
            }
            
            if([SecurityFactorTableViewCell appearance].imageWearablesFactor != nil)
                [imgView setImage:[SecurityFactorTableViewCell appearance].imageWearablesFactor];
            else
                [imgView setImage:[UIImage imageNamed:@"ic_bluetooth" inBundle:bundle compatibleWithTraitCollection:nil]];
            
            //tint image because inactive
            [imgView setAlpha:0.4];
            
            UIImage *imageButton = [[UIImage imageNamed:@"ic_delete" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [btnDelete setImage:imageButton forState:UIControlStateNormal];
        }
        else
        {
            labelActiveStatus.text = @"Active";
            
            if([SecurityFactorTableViewCell appearance].imageLocationsFactor != nil)
                [imgView setImage:[SecurityFactorTableViewCell appearance].imageLocationsFactor];
            else
                [imgView setImage:[UIImage imageNamed:@"ic_place" inBundle:bundle compatibleWithTraitCollection:nil]];
            
            UIImage *imageButton = [[UIImage imageNamed:@"ic_delete" inBundle:bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [btnDelete setImage:imageButton forState:UIControlStateNormal];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:tblFactors];
    return [tblFactors indexPathForRowAtPoint:buttonFrame.origin];
}

#pragma mark - Button Methods
- (IBAction)btnRemovePressed:(id)sender
{
    if(_mode == PINCODE)
    {
        SecurityPINCodeViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityPINCodeViewController"];
        fromVerifySwitch = NO;
        if(fromVerifySwitch)
        {
            vcPushedView.fromRemove = NO;
            vcPushedView.fromVerifySwitch = YES;
            vcPushedView.fromAdd = NO;
        }
        else
        {
            vcPushedView.fromRemove = YES;
            vcPushedView.fromVerifySwitch = NO;
            vcPushedView.fromAdd = NO;
        }
        
        [self.navigationController pushViewController:vcPushedView animated:NO];
    }
    if(_mode == CIRCLECODE)
    {
        SecurityCircleCodeViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityCircleCodeViewController"];
        fromVerifySwitch = NO;
        if(fromVerifySwitch)
        {
            vcPushedView.fromRemove = NO;
            vcPushedView.fromVerifySwitch = YES;
            vcPushedView.fromAdd = NO;
        }
        else
        {
            vcPushedView.fromRemove = YES;
            vcPushedView.fromVerifySwitch = NO;
            vcPushedView.fromAdd = NO;
        }
        
        [self.navigationController pushViewController:vcPushedView animated:NO];
    }
    if(_mode == FINGERPRINTSCAN || _mode == FACESCAN)
    {
        fromVerifySwitch = NO;
        
        if([LKCFingerprintScanManager isTouchIDAvailable])
        {
            [LKCFingerprintScanManager removeFingerprintScanWithCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                if(success)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error.localizedFailureReason];
                }
            }];
        }
        else
        {
            [LKCFaceScanManager removeFaceScanWithCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                if(success)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error.localizedFailureReason];
                }
            }];
        }
    }
    
    if(_mode == LOCATIONS)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"settings_dialog_remove_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                       message:NSLocalizedStringFromTableInBundle(@"geofencing_settings_dialog_removeall_message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *btnYes = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Yes", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self removeAllLocations];
                                    }];
        
        UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action)
                                   {
                                   }];
        
        [alert addAction:btnCancel];
        [alert addAction:btnYes];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if(_mode == WEARABLES)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"settings_dialog_remove_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                       message:NSLocalizedStringFromTableInBundle(@"bluetooth_settings_dialog_removeall_message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *btnYes = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Yes", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [self removeAllWearables];
                                 }];
        
        UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action)
                                    {
                                    }];
        
        [alert addAction:btnCancel];
        [alert addAction:btnYes];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)btnDeletePressed:(id)sender
{
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    indexPathSelected = indexPath;
        
    if(_mode == LOCATIONS)
    {
         LKCLocation *location = [locationsArray objectAtIndex:indexPathSelected.item];
         NSString *timeAdded = location.timeRemainingUntilAdded;
         NSString *timeRemoved = location.timeRemainingUntilRemoved;
        
        [LKCLocationsManager getLocationsWithCompletion:^(NSArray *locations) {
            if([locations count] == 0)
            {
                [self.navigationController popViewControllerAnimated:NO];
                return;
            }
            else if(locationsArray.count != locations.count)
            {
                [self handleRefresh:self];
                return;
            }
            else
            {
                if(timeAdded == NULL && timeRemoved != NULL)
                {
                    // Removed in... Undo and make active again
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"settings_dialog_cancel_removal_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                                   message:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Removal_Undo_Geofence",@"Localizable", [NSBundle LaunchKeyUIBundle], nil), location.name]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *btnYes = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Yes", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self cancelRemoveLocation];
                                             }];
                    
                    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                        style:UIAlertActionStyleCancel
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                }];
                    
                    [alert addAction:btnCancel];
                    [alert addAction:btnYes];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"settings_dialog_remove_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                                   message:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"geofencing_settings_dialog_removesingle_message_format",@"Localizable", [NSBundle LaunchKeyUIBundle], nil), location.name]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *btnYes = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Yes", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self removeSingleLocation];
                                             }];
                    
                    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                        style:UIAlertActionStyleCancel
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                }];
                    
                    [alert addAction:btnCancel];
                    [alert addAction:btnYes];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }];
    }
    
    if(_mode == WEARABLES)
    {
         LKCWearable *wearable = [wearablesArray objectAtIndex:indexPathSelected.item];
         NSString *timeAdded = wearable.timeRemainingUntilAdded;
         NSString *timeRemoved = wearable.timeRemainingUntilRemoved;
        
        [LKCWearablesManager getStoredWearablesWithCompletion:^(NSArray *wearables) {
            if([wearables count] == 0)
            {
                [self.navigationController popViewControllerAnimated:NO];
            }
            else if(wearablesArray.count != wearables.count)
            {
                [self handleRefresh:self];
                return;
            }
            else
            {
                if(timeAdded == NULL && timeRemoved != NULL)
                {
                    // Removed in...
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"settings_dialog_cancel_removal_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                                   message:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Removal_Undo_Bluetooth",@"Localizable", [NSBundle LaunchKeyUIBundle], nil), wearable.name]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *btnYes = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Yes", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self cancelRemoveWearable];
                                             }];
                    
                    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                        style:UIAlertActionStyleCancel
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                }];
                    
                    [alert addAction:btnCancel];
                    [alert addAction:btnYes];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"settings_dialog_remove_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                                   message:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"bluetooth_settings_dialog_removesingle_message_format",@"Localizable", [NSBundle LaunchKeyUIBundle], nil), wearable.name]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *btnYes = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Yes", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self removeSingleWearable];
                                             }];
                    
                    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                        style:UIAlertActionStyleCancel
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                }];
                    
                    [alert addAction:btnCancel];
                    [alert addAction:btnYes];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }];
    }
}

- (void)stateChanged:(UISwitch *)switchState
{
    if(_mode == PINCODE)
    {
        SecurityPINCodeViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityPINCodeViewController"];
        fromVerifySwitch = YES;
        if(fromVerifySwitch)
        {
            vcPushedView.fromRemove = NO;
            vcPushedView.fromVerifySwitch = YES;
            vcPushedView.fromAdd = NO;
        }
        else
        {
            vcPushedView.fromRemove = YES;
            vcPushedView.fromVerifySwitch = NO;
            vcPushedView.fromAdd = NO;
        }
        
        [self.navigationController pushViewController:vcPushedView animated:NO];
    }
    if(_mode == CIRCLECODE)
    {
        SecurityCircleCodeViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityCircleCodeViewController"];
        fromVerifySwitch = YES;
        if(fromVerifySwitch)
        {
            vcPushedView.fromRemove = NO;
            vcPushedView.fromVerifySwitch = YES;
            vcPushedView.fromAdd = NO;
        }
        else
        {
            vcPushedView.fromRemove = YES;
            vcPushedView.fromVerifySwitch = NO;
            vcPushedView.fromAdd = NO;
        }
        
        [self.navigationController pushViewController:vcPushedView animated:NO];
    }
    if(_mode == WEARABLES)
    {
        [LKCWearablesManager changeVerificationFlagWithCompletion:^(NSString *timeRemaining) {
            
            if(timeRemaining == nil || [timeRemaining isEqualToString:@"Now"])
            {
                labelChangeEffectiveIn.hidden = YES;
                
                if ([LKCWearablesManager getVerificationFlag].state == ALWAYS)
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = true;
                }
                else
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = false;
                }
            }
            else
            {
                labelChangeEffectiveIn.hidden = NO;
                labelChangeEffectiveIn.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_extra_format", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), timeRemaining];
                
                if ([LKCWearablesManager getVerificationFlag].state == WHENREQUIRED)
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = true;
                }
                else
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = false;
                }
            }
        }];
    }
    if(_mode == LOCATIONS)
    {
        [LKCLocationsManager changeVerificationFlagWithCompletion:^(NSString *timeRemaining) {
            
            if(timeRemaining == nil || [timeRemaining isEqualToString:@"Now"])
            {
                labelChangeEffectiveIn.hidden = YES;
                
                if ([LKCLocationsManager getVerificationFlag].state == ALWAYS)
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = true;
                }
                else
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = false;
                }
            }
            else
            {
                labelChangeEffectiveIn.hidden = NO;
                labelChangeEffectiveIn.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_extra_format", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), timeRemaining];
                
                if ([LKCLocationsManager getVerificationFlag].state == WHENREQUIRED)
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = true;
                }
                else
                {
                    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    switchVerify.on = false;
                }
            }
        }];
    }
    if(_mode == FINGERPRINTSCAN || _mode == FACESCAN)
    {
        if([LKCFingerprintScanManager isTouchIDAvailable])
        {
            [LKCFingerprintScanManager changeVerificationFlagWithCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                if(success)
                {
                    [self setUpTableHeader];
                }
                else
                {
                    [switchVerify setOn:![switchVerify isOn]];
                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error.localizedFailureReason];
                }
            }];
        }
        else
        {
            [LKCFaceScanManager changeVerificationFlagWithCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                if(success)
                {
                    [self setUpTableHeader];
                }
                else
                {
                    [switchVerify setOn:![switchVerify isOn]];
                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error.localizedFailureReason];
                }
            }];
        }
    }
}

#pragma mark - Remove Methods
-(void)removeAllLocations
{
    // Remove all geo-fences
    [[[self navigationController] navigationBar] setUserInteractionEnabled:NO];
    [LKCLocationsManager getLocationsWithCompletion:^(NSArray *locations) {
        locationsArray = locations;
        for(int i = 0; i < [locationsArray count]; i++)
        {
            [LKCLocationsManager removeLocation:[locationsArray objectAtIndex:i] withCompletion:^(LKCLocation *location) {
                [LKCLocationsManager getLocationsWithCompletion:^(NSArray *locations) {
                    if([locations count] == 0)
                    {
                        [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    else if(i == [locationsArray count] - 1)
                    {
                        locationsArray = locations;
                    }
                }];
            }];
            [tblFactors reloadData];
            [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
        }
    }];
}

-(void)removeAllWearables
{
    [[[self navigationController] navigationBar] setUserInteractionEnabled:NO];
    [LKCWearablesManager getStoredWearablesWithCompletion:^(NSArray *wearables) {
        wearablesArray = wearables;
        for(int i = 0; i < [wearablesArray count]; i++)
        {
            [LKCWearablesManager removeWearable:[wearablesArray objectAtIndex:i] withCompletion:^(LKCWearable *wearable) {
                [LKCWearablesManager getStoredWearablesWithCompletion:^(NSArray *wearables) {
                    if([wearables count] == 0)
                    {
                        [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    else if(i == [wearablesArray count] - 1)
                    {
                        wearablesArray = wearables;
                    }
                }];
            }];
        [tblFactors reloadData];
        [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
        }
    }];
}

-(void)removeSingleLocation
{
    LKCLocation *locationToBeRemoved = [locationsArray objectAtIndex:(int)indexPathSelected.item];
    
    [LKCLocationsManager removeLocation:locationToBeRemoved withCompletion:^(LKCLocation *location) {
        [LKCLocationsManager getLocationsWithCompletion:^(NSArray *locations) {
            locationsArray = locations;
            if([locationsArray count] == 0)
            {
                [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
                [self.navigationController popViewControllerAnimated:NO];
            }
            else
            {
                [tblFactors reloadData];
            }
        }];
    }];
}

-(void)cancelRemoveLocation
{
    LKCLocation *locationToBeCanceled = [locationsArray objectAtIndex:(int)indexPathSelected.item];
    
    [LKCLocationsManager cancelRemove:locationToBeCanceled withCompletion:^(LKCLocation *location, NSString *error) {
        [LKCLocationsManager getLocationsWithCompletion:^(NSArray *locations) {
            locationsArray = locations;
            if([locationsArray count] == 0)
            {
                [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
                [self.navigationController popViewControllerAnimated:NO];
            }
            else
            {
                [tblFactors reloadData];
            }
        }];
    }];
}

-(void)removeSingleWearable
{
    LKCWearable *wearableToBeRemoved = [wearablesArray objectAtIndex:(int)indexPathSelected.item];
    
    [LKCWearablesManager removeWearable:wearableToBeRemoved withCompletion:^(LKCWearable *wearable) {
        [LKCWearablesManager getStoredWearablesWithCompletion:^(NSArray *wearables) {
            wearablesArray = wearables;
            if([wearablesArray count] == 0)
            {
                [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
                [self.navigationController popViewControllerAnimated:NO];
            }
            else
            {
                [tblFactors reloadData];
            }
        }];
    }];
}

-(void)cancelRemoveWearable
{
    LKCWearable *wearableToBeCanceled = [wearablesArray objectAtIndex:(int)indexPathSelected.item];
    
    [LKCWearablesManager cancelRemove:wearableToBeCanceled withCompletion:^(LKCWearable *wearable, NSString *error) {
        [LKCWearablesManager getStoredWearablesWithCompletion:^(NSArray *wearables) {
            wearablesArray = wearables;
            if([wearablesArray count] == 0)
            {
                [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
                [self.navigationController popViewControllerAnimated:NO];
            }
            else
            {
                [tblFactors reloadData];
            }
        }];
    }];
}

#pragma mark - Refresh Control
-(void)handleRefresh:(id)sender
{
    if(_mode == LOCATIONS)
    {
        [LKCLocationsManager getLocationsWithCompletion:^(NSArray *locations) {
            locationsArray = locations;
            [tblFactors reloadData];
            [refreshControl endRefreshing];
        }];
    }
    else if(_mode == WEARABLES)
    {
        [LKCWearablesManager getStoredWearablesWithCompletion:^(NSArray *wearables) {
            wearablesArray = wearables;
            [tblFactors reloadData];
            [refreshControl endRefreshing];
        }];
    }
}

#pragma mark - Show Alert
-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message
{
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
