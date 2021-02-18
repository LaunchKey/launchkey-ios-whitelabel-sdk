//
//  ConfigTestingViewController.m
//  SampleAppObjC
//
//  Created by ani on 6/19/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

#import "ConfigTestingViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ConfigTestingViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate>
{
    NSArray *authMethodsArray;
    UISwitch *enablePIN, *enableCircle, *enableWearables, *enableLocations, *enableFingerprint, *enableFace, *allowSecurityChangesUnlinked, *dismissAuthRequestUponClose;
    UITextField *tfActivationDelayWearbale, *tfActivationDelayLocations, *tfAuthFailureThreshold, *tfAutoUnlinkThreshold, *tfAutoUnlinkWarningThreshold, *tfAuthSDKKey;
    BOOL awaitingLocationDisplay;
}

@property (weak, nonatomic) IBOutlet UITableView *tblConfigTesting;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ConfigTestingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Config Testing";
    
    // Initialize Auth Methods
    authMethodsArray = [NSArray arrayWithObjects:@"PIN Code", @"Circle Code", @"Wearables", @"Locations", @"Fingerprint Scan", @"Face Scan", nil];
    
    // Add Tap Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Initialize location service variables
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    awaitingLocationDisplay = false;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:_tblConfigTesting];
    CGPoint contentOffset = _tblConfigTesting.contentOffset;
    
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
    
    [_tblConfigTesting setContentOffset:contentOffset animated:YES];
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = (UITableViewCell*)textField.superview.superview;
        NSIndexPath *indexPath = [_tblConfigTesting indexPathForCell:cell];

        [_tblConfigTesting scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }

    return YES;
}

#pragma mark - TextField Methods
-(BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string
{
    if(textField.tag == 13)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        return YES;
    }
    return YES;
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return authMethodsArray.count + 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *authSDKKeyCellID = @"AuthSDKKeyCell";
    static NSString *authMethodCellID = @"AuthMethodCell";
    static NSString *activationDelayWearablesCellID = @"ActivationDelayWearablesCell";
    static NSString *activationDelayLocationsCellID = @"ActivationDelayLocationsCell";
    static NSString *authFailureThresholdCellID = @"AuthFailureThresholdCell";
    static NSString *autoUnlinkThresholdCellID = @"AutoUnlinkThresholdCell";
    static NSString *autoUnlinkWarningThresholdCellID = @"AutoUnlinkWarningThresholdCell";
    static NSString *securityChangesUnlinkedCellID = @"SecurityChangesUnlinkedCell";
    static NSString *dismissAuthRequestUponCloseCellID = @"DismissAuthRequestUponClose";
    static NSString *endpointCellID = @"EndpointCell";
    static NSString *reinitializeCellID = @"ReinitializeCell";
    static NSString *getDeviceLocationCellID = @"LocationCell";
    static NSString *buildHashID = @"BuildHash";
    
    if(indexPath.row == 0)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:authSDKKeyCellID];
        tfAuthSDKKey = (UITextField*)[cell viewWithTag:13];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        tfAuthSDKKey.text = [defaults objectForKey:@"sdkKey"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row >= 1 && indexPath.row < authMethodsArray.count+1)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:authMethodCellID];
        UILabel *labelAuthMethod = (UILabel*)[cell viewWithTag:1];
        
        if(indexPath.row == 1)
        {
            enablePIN = (UISwitch*)[cell viewWithTag:2];
            [enablePIN setOn:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enablePINCode];
            enablePIN.accessibilityIdentifier = @"pin_code_switch";
        }
        else if(indexPath.row == 2)
        {
            enableCircle = (UISwitch*)[cell viewWithTag:2];
            [enableCircle setOn:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableCircleCode];
            enableCircle.accessibilityIdentifier = @"circle_code_switch";
        }
        else if(indexPath.row == 3)
        {
            enableWearables = (UISwitch*)[cell viewWithTag:2];
            [enableWearables setOn:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableWearable];
            enableWearables.accessibilityIdentifier = @"wearables_switch";
        }
        else if(indexPath.row == 4)
        {
            enableLocations = (UISwitch*)[cell viewWithTag:2];
            [enableLocations setOn:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableLocations];
            enableLocations.accessibilityIdentifier = @"locations_switch";
        }
        else if(indexPath.row == 5)
        {
            enableFingerprint = (UISwitch*)[cell viewWithTag:2];
            [enableFingerprint setOn:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableFingerprint];
            enableFingerprint.accessibilityIdentifier = @"fingerprint_switch";
        }
        else if(indexPath.row == 6)
        {
            enableFace = (UISwitch*)[cell viewWithTag:2];
            [enableFace setOn:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableFace];
            enableFace.accessibilityIdentifier = @"face_scan_switch";
        }
        
        labelAuthMethod.text = [authMethodsArray objectAtIndex:indexPath.row-1];
        
        return cell;
    }
    else if(indexPath.row == 7)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:activationDelayWearablesCellID];
        tfActivationDelayWearbale = (UITextField*)[cell viewWithTag:3];
        tfActivationDelayWearbale.text = [NSString stringWithFormat:@"%d", [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable];
        tfActivationDelayWearbale.accessibilityIdentifier = @"delay_wearbles_text_field";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 8)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:activationDelayLocationsCellID];
        tfActivationDelayLocations = (UITextField*)[cell viewWithTag:4];
        tfActivationDelayLocations.text = [NSString stringWithFormat:@"%d", [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation];
        tfActivationDelayLocations.accessibilityIdentifier = @"delay_location_text_field";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 9)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:authFailureThresholdCellID];
        tfAuthFailureThreshold = (UITextField*)[cell viewWithTag:5];
        tfAuthFailureThreshold.text = [NSString stringWithFormat:@"%d", [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAuthFailure];
        tfAuthFailureThreshold.accessibilityIdentifier = @"auth_failure_threshold_text_field";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 10)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:autoUnlinkThresholdCellID];
        tfAutoUnlinkThreshold = (UITextField*)[cell viewWithTag:6];
        tfAutoUnlinkThreshold.text = [NSString stringWithFormat:@"%d", [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAutoUnlink];
        tfAutoUnlinkThreshold.accessibilityIdentifier = @"auto_unlink_threshold_text_field";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 11)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:autoUnlinkWarningThresholdCellID];
        tfAutoUnlinkWarningThreshold = (UITextField*)[cell viewWithTag:7];
        tfAutoUnlinkWarningThreshold.text = [NSString stringWithFormat:@"%d", [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAutoUnlinkWarning];
        tfAutoUnlinkWarningThreshold.accessibilityIdentifier = @"auto_unlink_warning_threshold";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 12)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:securityChangesUnlinkedCellID];
        allowSecurityChangesUnlinked = (UISwitch*)[cell viewWithTag:8];
        [allowSecurityChangesUnlinked setOn:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableSecurityChangesWhenUnlinked];
        allowSecurityChangesUnlinked.accessibilityIdentifier = @"allow_changes_unlinked_switch";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 13)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:dismissAuthRequestUponCloseCellID];
        dismissAuthRequestUponClose = (UISwitch*)[cell viewWithTag:8];
        [dismissAuthRequestUponClose setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"dismissAuthRequest"]];
        dismissAuthRequestUponClose.accessibilityIdentifier = @"dismiss_auth_request_upon_close";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 14)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:endpointCellID];
        
        NSString *endpointString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LKEndpoint"];
        UILabel *labelEndpoint = (UILabel*)[cell viewWithTag:9];
        labelEndpoint.text = [NSString stringWithFormat:@"Endpoint: %@", endpointString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 15)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:getDeviceLocationCellID];
        
        UIButton *btnGetLocation = (UIButton*)[cell viewWithTag:10];
        btnGetLocation.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        [btnGetLocation addTarget:self action:@selector(btnGetDeviceLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnGetLocation.accessibilityIdentifier = @"getLocation_button";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 16)
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:reinitializeCellID];
        
        UIButton *btnReinitialize = (UIButton*)[cell viewWithTag:11];
        btnReinitialize.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        [btnReinitialize addTarget:self action:@selector(btnReinitializePressed:) forControlEvents:UIControlEventTouchUpInside];
        btnReinitialize.accessibilityIdentifier = @"reinitialize_button";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:buildHashID];
        UILabel *labelEndpoint = (UILabel*)[cell viewWithTag:12];
        NSString *lastCommitHash = [[NSBundle mainBundle] infoDictionary][@"GIT_COMMIT_HASH"];
        labelEndpoint.text = [NSString stringWithFormat:@"Build Hash: %@", lastCommitHash];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - Button Methods
-(void)btnReinitializePressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([dismissAuthRequestUponClose isOn])
    {
        [defaults setObject:@"YES" forKey:@"dismissAuthRequest"];
    }
    else
    {
        [defaults setObject:@"NO" forKey:@"dismissAuthRequest"];
    }
    [defaults synchronize];
    @try {
        AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
            builder.enablePINCode = [enablePIN isOn];
            builder.enableCircleCode = [enableCircle isOn];
            builder.enableWearable = [enableWearables isOn];
            builder.enableLocations = [enableLocations isOn];
            builder.enableFingerprint = [enableFingerprint isOn];
            builder.enableFace = [enableFace isOn];

            if([tfAuthSDKKey hasText])
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:tfAuthSDKKey.text forKey:@"sdkKey"];
                [defaults synchronize];
            }
            if([tfActivationDelayWearbale hasText])
            {
                builder.activationDelayWearable = [tfActivationDelayWearbale.text intValue];
            }
            if([tfActivationDelayLocations hasText])
            {
                builder.activationDelayLocation = [tfActivationDelayLocations.text intValue];
            }
            if([tfAuthFailureThreshold hasText])
            {
                builder.thresholdAuthFailure = [tfAuthFailureThreshold.text intValue];
            }
            if([tfAutoUnlinkThreshold hasText])
            {
                builder.thresholdAutoUnlink = [tfAutoUnlinkThreshold.text intValue];
            }
            if([tfAutoUnlinkWarningThreshold hasText])
            {
                builder.thresholdAutoUnlinkWarning = [tfAutoUnlinkWarningThreshold.text intValue];
            }
            builder.enableSecurityChangesWhenUnlinked = [allowSecurityChangesUnlinked isOn];
        }];
        
        [[AuthenticatorManager sharedClient] initialize:config];
    }
    @catch(id anException) {
        NSString *title = @"SDK error";
        NSString *message = [NSString stringWithFormat:@"Cannot initialize SDK with these values"];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:title
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:nil];
        [alert addAction:okButton];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)btnGetDeviceLocationPressed:(id)sender
{
    if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied ||
        CLLocationManager.authorizationStatus == kCLAuthorizationStatusRestricted ||
        CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [[self locationManager] requestWhenInUseAuthorization];
        return;
    }
    awaitingLocationDisplay = YES;
    [[self locationManager] requestLocation];
}

#pragma mark - Location Services
-(void)displayLocation:(CLLocation*)location andCountry:(NSString*)country{
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", location.coordinate.longitude];
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", location.coordinate.latitude];
    NSString *title = @"Current Location";
    NSString *message = [NSString stringWithFormat:@"Latitude: %@,\nLongitude: %@, \nCountry: %@", latitude, longitude, country];
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (awaitingLocationDisplay) {
        awaitingLocationDisplay = NO;
        [self reverseGeocodeLocation:locations.lastObject];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - CLGeocoder Methods
-(void)reverseGeocodeLocation:(CLLocation*)location
{
    __block BOOL placeMarkUpdated = NO;
    CLGeocoder *geocoder = [CLGeocoder new];
    if (@available(iOS 11.0, *)) {
        [geocoder reverseGeocodeLocation:location preferredLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"] completionHandler:^(NSArray *placemarks, NSError *error) {
            if(placemarks && [placemarks count] > 0) {
                if (placeMarkUpdated == NO) {
                    placeMarkUpdated = YES;
                    CLPlacemark *placemark = placemarks[0];
                    [self displayLocation:location andCountry:placemark.ISOcountryCode];
                }
            }
        }];
    }
    else {
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if(placemarks && [placemarks count] > 0) {
                if (placeMarkUpdated == NO) {
                    placeMarkUpdated = YES;
                    CLPlacemark *placemark = placemarks[0];
                    [self displayLocation:location andCountry:placemark.ISOcountryCode];
                }
            }
        }];
    }
    while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !placeMarkUpdated){};
}

@end
