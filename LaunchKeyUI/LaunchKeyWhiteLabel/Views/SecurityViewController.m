//
//  SecurityViewController.m
//  WhiteLabel
//
//  Created by ani on 4/25/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "SecurityViewController.h"
#import "LKUIConstants.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "SettingsViewController.h"
#import "AuthenticatorManager.h"
#import "SecurityFactorTableViewCell.h"
#import "SecurityPINCodeViewController.h"
#import "SecurityCircleCodeViewController.h"
#import "SecurityBluetoothViewController.h"
#import "SecurityGeofenceViewController.h"
#import "SecurityFingerprintViewController.h"
#import "LaunchKeyUIBundle.h"
#import "NSDate+LKTimeAgo.h"
#import <LKCAuthenticator/LKCFaceScanManager.h>
#import <LKCAuthenticator/LKCFingerprintScanManager.h>
#import <LKCAuthenticator/LKCWearablesManager.h>
#import <LKCAuthenticator/LKCLocationsManager.h>
#import <LKCAuthenticator/LKCCircleCodeManager.h>
#import <LKCAuthenticator/LKCPINCodeManager.h>

@interface SecurityViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, SecurityGeofenceViewControllerDelegate, SecurityBluetoothViewControllerDelegate>
{
    BOOL pinEnabled,circleCodeEnabled, bluetoothEnabled, geofenceEnabled, fingerprintEnabled;
    BOOL fromPinView, fromCircleCodeView, fromBluetoothView, fromGeofenceView, fromFingerprintView;
    BOOL deviceFactorEnabled, geofenceEnabledOnly;
    
    UIBarButtonItem *rightAdd;
    
    BOOL fromAddView;
    
    NSString *path;
    NSBundle *bundle;
    BOOL hasCompletedAsyncSetup;
    UIActivityIndicatorView *loadingIndicator;
    UIAlertController *alertVC;
}

@end

@implementation SecurityViewController

@synthesize tblSecurityFactors;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bundle = [NSBundle LaunchKeyUIBundle];
    path = bundle.bundlePath;
    
    rightAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSelected:)];
    self.navigationItem.rightBarButtonItem = rightAdd;
    rightAdd.accessibilityLabel = @"security_add";
    rightAdd.enabled = NO;
    
    _labelNoAuthMethods.hidden = YES;
    tblSecurityFactors.hidden = YES;
    
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"navigation_security", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    fromAddView = NO;
    
    // Initialize all factors to NO
    pinEnabled = NO;
    circleCodeEnabled = NO;
    bluetoothEnabled = NO;
    geofenceEnabled = NO;
    fingerprintEnabled = NO;
    
    // Programmatically included settings around label due to limitations of Storyboard
    _labelNoAuthMethods.text = NSLocalizedStringFromTableInBundle(@"security_helpsheet_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
        [_labelNoAuthMethods setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:17]];
    _labelNoAuthMethods.textColor = [IOALabel appearance].textColor;
    _labelNoAuthMethods.adjustsFontSizeToFitWidth = YES;
    _labelNoAuthMethods.numberOfLines = 1;
    _labelNoAuthMethods.minimumScaleFactor = 0.6;
    _labelNoAuthMethods.textAlignment = NSTextAlignmentCenter;
    
    // Show a loading indicator while the viewController is being setup
    alertVC = [UIAlertController alertControllerWithTitle:NULL message:@"Please wait..." preferredStyle:UIAlertControllerStyleAlert];
    CGRect frame = CGRectMake(10,5,50,50);
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [loadingIndicator setHidesWhenStopped:YES];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator startAnimating];
    [[alertVC view] addSubview:loadingIndicator];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    hasCompletedAsyncSetup = NO;
    [self asyncSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self recheckEnabledSecurityFactors];
}

- (void)asyncSetup {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        fromPinView = NO;
        fromCircleCodeView = NO;
        fromBluetoothView = NO;
        fromGeofenceView = NO;
        fromFingerprintView = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pinSet:) name:@"pinSet" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(circleCodeSet:) name:@"circleCodeSet" object:nil];
        
        //Check which factors are enabled
        [self checkForFactors];
        
        if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableSecurityChangesWhenUnlinked)
        {
            [self disableView];
            [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Device_Unlinked_Error_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Device_Unlinked_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
        }
        else
        {
            [self enableView];
        }
        
        [self setCorrectHiddenStateForNoAuthLabel];
        rightAdd.enabled = YES;
        hasCompletedAsyncSetup = YES;
        [alertVC dismissViewControllerAnimated:NO completion:^{
            alertVC = NULL;
            loadingIndicator = NULL;
        }];
        
        [tblSecurityFactors reloadData];
    });
}

- (void)setCorrectHiddenStateForNoAuthLabel {
    if(!pinEnabled && !circleCodeEnabled && !geofenceEnabled && !bluetoothEnabled && !fingerprintEnabled)
    {
        _labelNoAuthMethods.hidden = NO;
        tblSecurityFactors.hidden = YES;
    }
    else
    {
        _labelNoAuthMethods.hidden = YES;
        tblSecurityFactors.hidden = NO;
    }
}

- (void)recheckEnabledSecurityFactors {
    if (hasCompletedAsyncSetup == YES ) {
        //Check which factors are enabled
        [self checkForFactors];
        
        //there are no security factors
        [self setCorrectHiddenStateForNoAuthLabel];
    }
}

#pragma mark - Disable View
-(void)disableView
{
    tblSecurityFactors.userInteractionEnabled = NO;
}

#pragma mark - Enable View
-(void)enableView
{
    tblSecurityFactors.userInteractionEnabled = YES;
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

#pragma mark - get current time stamp
- (NSString*)timeStamp
{
    return [NSString stringWithFormat:@"%lu", (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970])];
}

#pragma mark - check for factors
-(void)checkForFactors
{
    pinEnabled = [LKCPINCodeManager isPINCodeSet];
    circleCodeEnabled = [LKCCircleCodeManager isCircleCodeSet];\
    fingerprintEnabled = [LKCFingerprintScanManager isFingerprintScanSet] || [LKCFaceScanManager isFaceScanSet];
    
    [LKCLocationsManager getLocationsWithCompletion:^(NSArray *locations) {
        if(locations.count > 0)
        {
            geofenceEnabled = YES;
        }
        else
        {
            geofenceEnabled = NO;
        }
        
        [tblSecurityFactors reloadData];
    }];
    
    [LKCWearablesManager getStoredWearablesWithCompletion:^(NSArray *wearables) {
        if(wearables.count > 0)
        {
            bluetoothEnabled = YES;
        }
        else
        {
            bluetoothEnabled = NO;
        }
        
        [tblSecurityFactors reloadData];
    }];
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
        sectionHeader = NSLocalizedStringFromTableInBundle(@"Currently_Enabled", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
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
    if(indexPath.row == 0)
        if(!pinEnabled)
            return 0.0;
    if(indexPath.row == 1)
        if(!circleCodeEnabled)
            return 0.0;
    if(indexPath.row == 2)
        if(!bluetoothEnabled)
            return 0.0;
    if(indexPath.row == 3)
        if(!geofenceEnabled)
            return 0.0;
    if(indexPath.row == 4)
        if (!fingerprintEnabled)
            return 0.0;
    
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"SecurityFactorCell";
    SecurityFactorTableViewCell *cell = (SecurityFactorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[SecurityFactorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Set Cell Tags
    UIImageView *imgSecurityFactor = (UIImageView *)[cell viewWithTag:1];
    UILabel *labelSecurityFactorName = (UILabel*)[cell viewWithTag:2];
    UILabel *labelVerificationStatus = (UILabel*)[cell viewWithTag:3];
    
    // Set Colors
    labelSecurityFactorName.textColor= [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    labelVerificationStatus.textColor = [[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor colorWithAlphaComponent:0.5];
    
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
    {
        [labelSecurityFactorName setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:labelSecurityFactorName.font.pointSize]];
        [labelVerificationStatus setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:labelVerificationStatus.font.pointSize]];
    }

    // PIN Code, Cirlce Code, Wearables, Locations, Fingerprint Scan / Face Scan
    if (indexPath.row == 0)
    {
        if([SecurityFactorTableViewCell appearance].imagePINCodeFactor != nil)
            [imgSecurityFactor setImage:[SecurityFactorTableViewCell appearance].imagePINCodeFactor];
        else
        {
            [imgSecurityFactor setImage:[UIImage imageNamed:@"ic_dialpad" inBundle:bundle compatibleWithTraitCollection:nil]];
            imgSecurityFactor.image = [imgSecurityFactor.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
        labelSecurityFactorName.text = NSLocalizedStringFromTableInBundle(@"security_pincode", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        
        if([LKCPINCodeManager getVerificationFlag].state == ALWAYS)
            labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_Always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        else
            labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_When_Required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    if(indexPath.row == 1)
    {
        if([SecurityFactorTableViewCell appearance].imageCircleCodeFactor != nil)
            [imgSecurityFactor setImage:[SecurityFactorTableViewCell appearance].imageCircleCodeFactor];
        else
        {
            [imgSecurityFactor setImage:[UIImage imageNamed:@"ic_settings_backup_restore" inBundle:bundle compatibleWithTraitCollection:nil]];
            imgSecurityFactor.image = [imgSecurityFactor.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }

        labelSecurityFactorName.text = NSLocalizedStringFromTableInBundle(@"security_circlecode", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        
        if([LKCCircleCodeManager getVerificationFlag].state == ALWAYS)
            labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_Always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        else
            labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_When_Required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    if(indexPath.row == 2)
    {
        if([SecurityFactorTableViewCell appearance].imageWearablesFactor != nil)
            [imgSecurityFactor setImage:[SecurityFactorTableViewCell appearance].imageWearablesFactor];
        else
        {
            [imgSecurityFactor setImage:[UIImage imageNamed:@"ic_bluetooth" inBundle:bundle compatibleWithTraitCollection:nil]];
            imgSecurityFactor.image = [imgSecurityFactor.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    
        labelSecurityFactorName.text = NSLocalizedStringFromTableInBundle(@"security_bluetooth", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        
        if([LKCWearablesManager getVerificationFlag].state == ALWAYS)
        {
            if(![LKCWearablesManager getVerificationFlag].pendingSwitch)
            {
                labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_Always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            }
            else
            {
                labelVerificationStatus.text = [NSString stringWithFormat:@"%@ (for %@)", NSLocalizedStringFromTableInBundle(@"Security_Checking_Always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [LKCWearablesManager getVerificationFlag].timeRemainingUntilFlagIsChanged];
            }
        }
        else
        {
            if(![LKCWearablesManager getVerificationFlag].pendingSwitch)
            {
                labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_When_Required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            }
            else
            {
                labelVerificationStatus.text = [NSString stringWithFormat:@"%@ (for %@)", NSLocalizedStringFromTableInBundle(@"Security_Checking_When_Required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [LKCWearablesManager getVerificationFlag].timeRemainingUntilFlagIsChanged];
            }
        }
    }
    if(indexPath.row == 3)
    {
        if([SecurityFactorTableViewCell appearance].imageLocationsFactor != nil)
            [imgSecurityFactor setImage:[SecurityFactorTableViewCell appearance].imageLocationsFactor];
        else
        {
            [imgSecurityFactor setImage:[UIImage imageNamed:@"ic_place" inBundle:bundle compatibleWithTraitCollection:nil]];
            imgSecurityFactor.image = [imgSecurityFactor.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
        labelSecurityFactorName.text = NSLocalizedStringFromTableInBundle(@"security_geofencing", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        
        if([LKCLocationsManager getVerificationFlag].state == ALWAYS)
        {
            if(![LKCLocationsManager getVerificationFlag].pendingSwitch)
            {
                labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_Always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            }
            else
            {
                labelVerificationStatus.text = [NSString stringWithFormat:@"%@ (for %@)", NSLocalizedStringFromTableInBundle(@"Security_Checking_Always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [LKCLocationsManager getVerificationFlag].timeRemainingUntilFlagIsChanged];
            }
        }
        else
        {
            if(![LKCLocationsManager getVerificationFlag].pendingSwitch)
            {
                labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_When_Required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
            }
            else
            {
                labelVerificationStatus.text = [NSString stringWithFormat:@"%@ (for %@)", NSLocalizedStringFromTableInBundle(@"Security_Checking_When_Required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [LKCLocationsManager getVerificationFlag].timeRemainingUntilFlagIsChanged];
            }
        }
    }
    if(indexPath.row == 4)
    {
        if(![LKCFingerprintScanManager isTouchIDAvailable])
        {
            if([SecurityFactorTableViewCell appearance].imageFingerprintFactor != nil)
                [imgSecurityFactor setImage:[SecurityFactorTableViewCell appearance].imageFingerprintFactor];
            else
            {
                [imgSecurityFactor setImage:[UIImage imageNamed:@"facescan_image" inBundle:bundle compatibleWithTraitCollection:nil]];
                imgSecurityFactor.image = [imgSecurityFactor.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            
            labelSecurityFactorName.text = NSLocalizedStringFromTableInBundle(@"security_facescan", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        }
        else
        {
            if([SecurityFactorTableViewCell appearance].imageFingerprintFactor != nil)
                [imgSecurityFactor setImage:[SecurityFactorTableViewCell appearance].imageFingerprintFactor];
            else
            {
                [imgSecurityFactor setImage:[UIImage imageNamed:@"ic_fingerprint_2x" inBundle:bundle compatibleWithTraitCollection:nil]];
                imgSecurityFactor.image = [imgSecurityFactor.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            
            labelSecurityFactorName.text = NSLocalizedStringFromTableInBundle(@"security_fingerprint", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        }
        
        if([LKCFingerprintScanManager getVerificationFlag].state == ALWAYS)
            labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_Always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        else
            labelVerificationStatus.text = NSLocalizedStringFromTableInBundle(@"Security_Checking_When_Required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    
    BOOL showImage = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableSecurityFactorImages;
    if(!showImage)
        imgSecurityFactor.hidden = YES;
    
    // Set Color Configuration of Image
    imgSecurityFactor.tintColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityFactorImageTintColor;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:tblSecurityFactors];
    return [tblSecurityFactors indexPathForRowAtPoint:buttonFrame.origin];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    
    if (indexPath.row == 0)
    {
        vcPushedView.mode = PINCODE;
    }
    if(indexPath.row == 1)
    {
        vcPushedView.mode = CIRCLECODE;
    }
    if(indexPath.row == 2)
    {
        vcPushedView.mode = WEARABLES;
    }
    if(indexPath.row == 3)
    {
        vcPushedView.mode = LOCATIONS;
    }
    if(indexPath.row == 4)
    {
        vcPushedView.mode = FINGERPRINTSCAN;
    }
    
    // Adding this so that if implementor is using a tab bar, the security views will hide the tab bar so that users cannot leave views
    // This line will not break anyone's current implementation (if they're using a navigation controller)
    vcPushedView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcPushedView animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Menu Methods
-(void)addSelected:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"Available_Factors_Alert_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"security_pincode", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

                                    dispatch_async(dispatch_get_main_queue(),^{
                                        SecurityPINCodeViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityPINCodeViewController"];
                                        vcPushedView.fromAdd = fromAddView;
                                        // Adding this so that if implementor is using a tab bar, the security views will hide the tab bar so that users cannot leave views
                                        // This line will not break anyone's current implementation (if they're using a navigation controller)
                                        vcPushedView.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vcPushedView animated:NO];
                                    });
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"security_circlecode", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        SecurityCircleCodeViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityCircleCodeViewController"];
                                        vcPushedView.fromAdd = fromAddView;
                                        // Adding this so that if implementor is using a tab bar, the security views will hide the tab bar so that users cannot leave views
                                        // This line will not break anyone's current implementation (if they're using a navigation controller)
                                        vcPushedView.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vcPushedView animated:NO];
                                    });
                                                           }];
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"security_bluetooth", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        SecurityBluetoothViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityBluetoothViewController"];
                                        vcPushedView.fromAdd = fromAddView;
                                        vcPushedView.delegate = self;
                                        // Adding this so that if implementor is using a tab bar, the security views will hide the tab bar so that users cannot leave views
                                        // This line will not break anyone's current implementation (if they're using a navigation controller)
                                        vcPushedView.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vcPushedView animated:NO];
                                    });
                                                          }];
    UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"security_geofencing", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        SecurityGeofenceViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityGeofenceViewController"];
                                        vcPushedView.fromAdd = fromAddView;
                                        vcPushedView.delegate = self;
                                        // Adding this so that if implementor is using a tab bar, the security views will hide the tab bar so that users cannot leave views
                                        // This line will not break anyone's current implementation (if they're using a navigation controller)
                                        vcPushedView.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vcPushedView animated:NO];
                                    });
                                                           }];
    NSString *biometricTitle = @"";
    if([LKCFaceScanManager isFaceIDAvailable])
        biometricTitle = NSLocalizedStringFromTableInBundle(@"security_facescan", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    else
        biometricTitle = NSLocalizedStringFromTableInBundle(@"security_fingerprint", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);

    UIAlertAction *fifthAction = [UIAlertAction actionWithTitle:biometricTitle
                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        SecurityFingerprintViewController *vcPushedView = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityFingerprintViewController"];
                                        // Adding this so that if implementor is using a tab bar, the security views will hide the tab bar so that users cannot leave views
                                        // This line will not break anyone's current implementation (if they're using a navigation controller)
                                        vcPushedView.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vcPushedView animated:NO];
                                    });
                                                          }];
    
    fromAddView = true;
    
    // Availability Flags
    const BOOL pinAvailable = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enablePINCode;
    const BOOL circleAvailable = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableCircleCode;
    const BOOL wearableAvailable = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableWearable;
    const BOOL geofenceAvailable = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableLocations;
    const BOOL fingerAvailable = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableFingerprint && [LKCFingerprintScanManager isTouchIDAvailable];
    const BOOL faceAvailable = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableFace && [LKCFaceScanManager isFaceIDAvailable];

    // Check if security factor should be enabled/disabled
    if(!pinEnabled && pinAvailable)
        [alert addAction:firstAction];
    if(!circleCodeEnabled && circleAvailable)
        [alert addAction:secondAction];
    if(!bluetoothEnabled && wearableAvailable)
        [alert addAction:thirdAction];
    if(!geofenceEnabled && geofenceAvailable)
        [alert addAction:fourthAction];
    if(!fingerprintEnabled && ([LKCFingerprintScanManager isTouchIDAvailable] || [LKCFaceScanManager isFaceIDAvailable]))
    {
        // Check if fingerprint is enabled AND Touch ID is available on device
        // Or if face is enabled AND Face ID is available on device
        if(fingerAvailable || faceAvailable)
                [alert addAction:fifthAction];
    }
    
    if(pinEnabled && circleCodeEnabled && geofenceEnabled && bluetoothEnabled && ((([LKCFingerprintScanManager isTouchIDAvailable] || [LKCFaceScanManager isFaceIDAvailable]) && fingerprintEnabled) || (![LKCFingerprintScanManager isTouchIDAvailable] && ![LKCFaceScanManager isFaceIDAvailable])))
    {
        //all security factors are enabled
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"All_Factors_Enabled_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"All_Factors_Enabled_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    }
    else if(!pinAvailable && !circleAvailable && !wearableAvailable && !geofenceAvailable && (!faceAvailable || !fingerAvailable))
    {
        //all security factors are disabled by config
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"All_Factors_Enabled_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"All_Factors_Unavailable_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    }
    else if((pinEnabled || !pinAvailable) && (circleCodeEnabled || !circleAvailable) && (bluetoothEnabled || !wearableAvailable) && (geofenceEnabled || !geofenceAvailable) && (fingerprintEnabled || (!fingerAvailable && !faceAvailable)))
    {
        //all security factors are either enabled or unavailable
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"All_Factors_Enabled_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"All_Factors_Enabled_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    }
    else if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableSecurityChangesWhenUnlinked)
    {
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Device_Unlinked_Error_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Device_Unlinked_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    }
    else
    {
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        alert.popoverPresentationController.barButtonItem = rightAdd;
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark- PIN Set
-(void)pinSet:(NSNotification *)params
{
    [tblSecurityFactors reloadData];
}

#pragma mark - Circle Code Set
-(void)circleCodeSet:(NSNotification *)params
{
    [tblSecurityFactors reloadData];
}

#pragma mark - Bluetooth Added
-(void)bluetoothAdded:(SecurityBluetoothViewController *)controller
{
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable != activationDelayMin)
    {
        NSDate *dateNow = [NSDate date];
        NSString *timeRemaining = [dateNow timeAgo:nil withAdjustmentFactor:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable];
        
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Bluetooth_Pending_Activation_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Bluetooth_Pending_Activation_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), timeRemaining]];
         });
    }
}

#pragma mark - Geofence Added
-(void)geofenceAdded:(SecurityGeofenceViewController *)controller
{
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation != activationDelayMin)
    {
        NSDate *dateNow = [NSDate date];
        NSString *timeRemaining = [dateNow timeAgo:nil withAdjustmentFactor:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation];
        
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Geofence_Pending_Activation_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Geofence_Pending_Activation_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), timeRemaining]];
         });
    }
}

@end
