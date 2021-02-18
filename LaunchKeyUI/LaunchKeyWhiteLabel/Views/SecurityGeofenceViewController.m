//
//  SecurityGeofenceViewController.m
//  LaunchKey
//
//  Created by ani on 12/15/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "SecurityGeofenceViewController.h"
#import "MKMapView+LKZoomLevel.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewController.h"
#import "LKUIConstants.h"
#import "AuthenticatorManager.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCLocationsManager.h>
#import <LKCAuthenticator/LKCErrorCode.h>

@interface SecurityGeofenceViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
{
    MKPointAnnotation *point;
    MKCircle *circle;
    float startRadius, geoLatitude, geoLongitude, geoRadius;
    UIPinchGestureRecognizer *pinchGesture;
    int minZoomLevel;
    BOOL startPinch, shouldHandleLongPress, geoFenceNameDataValid, circleSet, initialRegionSet, popView;
    CLLocationManager *locationManager;
}

@end

@implementation SecurityGeofenceViewController

#define MapViewDivisor 18
#define InitialUserLocationZoom .04

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize values
    startRadius = 0.0;
    minZoomLevel = 15;
    geoFenceNameDataValid = NO;
    popView = NO;

    // Set up navivation bar
    UIBarButtonItem *rightSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    UIButton *rightHelpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [rightHelpButton addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightHelp = [[UIBarButtonItem alloc] initWithCustomView:rightHelpButton];
    [rightSave setAccessibilityIdentifier:@"action_save"];

    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightSave, rightHelp, nil]];
    else
        self.navigationItem.rightBarButtonItem = rightSave;
    
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Title_Add_GeoFence", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    [_mapView setShowsUserLocation:YES];
    [_mapView setMapType:MKMapTypeStandard];
    _mapView.isAccessibilityElement = YES;
    _mapView.accessibilityLabel = @"Map";
    _mapView.accessibilityIdentifier = @"geofencing_add_mapfragment";
    
    // Initialize localtionManager and request Authorization
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager setDelegate:self];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    // If location services is not enabled, show alert
    if([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        popView = YES;
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Geofence_Location_Denied_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Geofence_Location_Denied_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    }
    else
        [self finishMapViewSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Finish MapView Setup & Add Gestures
-(void)finishMapViewSetup
{
    // Create Circle showing user's location
    circle = [MKCircle circleWithCenterCoordinate:_mapView.centerCoordinate radius:MKMapRectGetWidth(_mapView.visibleMapRect) /MapViewDivisor];
    
    [self addGestures];
}

-(void)addGestures
{
    // Initialize Gesture Recognizers
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.delegate = self;
    [_mapView addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture requireGestureRecognizerToFail: doubleTapGestureRecognizer];
    [_mapView addGestureRecognizer:tapGesture];
    
    // Initialize Pinch Gesture
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGesture.delegate = self;
    [_mapView addGestureRecognizer:pinchGesture];

    // Initialize Long Press Gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.delegate = self;
    [_mapView addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(pan:)];
    panGesture.delegate = self;
    [panGesture setMinimumNumberOfTouches:1];
    [_mapView addGestureRecognizer:panGesture];
    
    // Dismiss Keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Dismiss Keyboard
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Location Manager Delegation Methods
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusDenied)
    {
        popView = YES;
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Geofence_Location_Denied_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Geofence_Location_Denied_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    }
}

#pragma mark - Menu Methods
-(void)helpPressed:(id)sender
{
    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"About_Geofencing_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"help_security_add_geo", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
}

-(void)savePressed:(id)sender
{
    //if circle is null, warn user to select a geo-fence
    if (geoLongitude == 0.0  || geoLatitude == 0.0 || geoRadius == 0.0)
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Wait", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Geofence_Tap", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"Geofence_Name_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *btnOkay = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       UITextField *tfGeofenceName = alert.textFields[0];
                                       
                                       [tfGeofenceName resignFirstResponder];
                                       NSString *geoName = tfGeofenceName.text;
                                       NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
                                       NSString *warning;
                                       NSString *geofenceName;
                                       
                                       if(geoName == NULL || [geoName isEqualToString:@""] || ([[geoName stringByTrimmingCharactersInSet: set] length] == 0))
                                       {
                                           warning = NSLocalizedStringFromTableInBundle(@"Geofence_Name", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                                           [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Geofence_Name_Missing_Error_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:warning];
                                           return;
                                       }
                                       else if (geoName.length < methodNameMinimum)
                                       {
                                           warning = NSLocalizedStringFromTableInBundle(@"Warning_Four_Characters_Geofence", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                                           [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Geofence_Name_Invalid_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:warning];
                                           return;
                                       }
                                       else
                                       {
                                           geofenceName = geoName;
                                           geoFenceNameDataValid = YES;
                                       }
                                       
                                       if(geoFenceNameDataValid)
                                       {
                                             
                                            LKCLocation *location = [LKCLocation new];
                                            location.name = geoName;
                                            location.latitude = [NSString stringWithFormat:@"%f", geoLatitude];
                                            location.longitude = [NSString stringWithFormat:@"%f", geoLongitude];
                                            location.radius = [NSString stringWithFormat:@"%f", geoRadius];
                                            NSError *addLocationError = [LKCLocationsManager addLocation:location];
                                            if(addLocationError != nil)
                                            {
                                                if(addLocationError.code == LocationAlreadyAddedError)
                                                {
                                                    warning = NSLocalizedStringFromTableInBundle(@"Device_Factor_Name_Taken", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                                                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Geofence_Name_Invalid_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:warning];
                                                    return;
                                                }
                                            }
                                           
                                            [self showInformationAlert:NSLocalizedStringFromTableInBundle(@"Geofence_Added", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                                            
                                            //show verified for a bit
                                            double delayInSeconds = 1.0;
                                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                
                                                if(_fromAdd)
                                                    [self.delegate geofenceAdded:self];
                                                
                                                [self.navigationController popViewControllerAnimated:NO];
                                            });
                                       }
                                   }];
        UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action)
                                   {
                                   }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.accessibilityLabel = @"geo_text_field";
             textField.accessibilityIdentifier = @"setname_edit_name";
         }];
        
        [alert addAction:btnCancel];
        [alert addAction:btnOkay];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - MapView Delegate Methods
-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    popView = YES;
    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Error_No_Connection_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Error_No_Connection_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) ];
}

-(void)longPress:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        shouldHandleLongPress = YES;
        _mapView.scrollEnabled = NO;
        [self changeCircle:sender];
    } else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateEnded) {
        shouldHandleLongPress = NO;
        _mapView.scrollEnabled = YES;
    }
}

-(void)pan:(UIPanGestureRecognizer *)sender {
    if (shouldHandleLongPress) {
        [self changeCircle:sender];
    }
}

-(void)changeCircle:(UIGestureRecognizer *)sender {
    
    float newRadius = circle.radius;
    
    if (newRadius < kLKGeoFenceMiniumuRadius)
        newRadius = kLKGeoFenceMiniumuRadius;
    
    CGPoint touchPoint = [sender locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    [_mapView removeAnnotation:point];
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = touchMapCoordinate;
    [_mapView addAnnotation:point];
    
    MKCircle *newCircle = [MKCircle circleWithCenterCoordinate:touchMapCoordinate radius:newRadius];
    newCircle.title = @"Location 1";
    
    [_mapView addOverlay:newCircle];
    [_mapView removeOverlay:circle];
    [_mapView setNeedsDisplay];
    
    circle = newCircle;
    
    // Update geofence latitude and longitude
    geoLatitude = touchMapCoordinate.latitude;
    geoLongitude = touchMapCoordinate.longitude;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        //if inside the circle
        CGPoint touchPoint = [sender locationInView:_mapView];
        CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
        
        MKMapPoint mapPoint = MKMapPointForCoordinate(touchMapCoordinate);
        
        CGPoint mapPointAsCGP = CGPointMake(mapPoint.x, mapPoint.y);
        
        MKCircleRenderer* circleView = [[MKCircleRenderer alloc] initWithCircle:circle];
        
        BOOL mapCoordinateIsInPolygon = CGPathContainsPoint(circleView.path, NULL, mapPointAsCGP, FALSE);
        
        if (mapCoordinateIsInPolygon)
        {
            startRadius = circle.radius;
            startPinch = YES;
            _mapView.zoomEnabled = NO;
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (startPinch)
        {
            float newRadius = startRadius *  [sender scale];
            
            if (newRadius < kLKGeoFenceMiniumuRadius)
                newRadius = kLKGeoFenceMiniumuRadius;
            
            geoRadius = newRadius;
            
            MKCircle *newCircle = [MKCircle circleWithCenterCoordinate:circle.coordinate radius:newRadius];
            newCircle.title = @"Location 1";
            [_mapView addOverlay:newCircle];
            
            [_mapView removeOverlay:circle];
            [_mapView setNeedsDisplay];
            
            circle = newCircle;
        }
    }
    else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateEnded)
    {
        startPinch = NO;
        _mapView.zoomEnabled = YES;
        
        //force a refresh
        [_mapView removeOverlay:circle];
        [_mapView addOverlay:circle];
    }
}

- (void)mapView:(MKMapView *)thisMapView regionDidChangeAnimated:(BOOL)animated
{
    int zoomLevel = (int)[_mapView zoomLevel];
    if(zoomLevel  > minZoomLevel)
        [_mapView setCenterCoordinate:_mapView.centerCoordinate
                            zoomLevel:minZoomLevel
                             animated:NO];
}

- (void)mapView:(MKMapView *)thisMapView regionWillChangeAnimated:(BOOL)animated
{
    int zoomLevel = (int)[_mapView zoomLevel];
    if(zoomLevel  > minZoomLevel)
        [_mapView setCenterCoordinate:_mapView.centerCoordinate
                            zoomLevel:minZoomLevel
                             animated:NO];
}

-(void)mapView:(MKMapView *)mView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (userLocation.location == nil)
        return;

    if(!initialRegionSet)
    {
        initialRegionSet = YES;

        MKCoordinateRegion region;
        region.center = mView.userLocation.coordinate;

        MKCoordinateSpan span;
        span.latitudeDelta  = InitialUserLocationZoom;
        span.longitudeDelta = InitialUserLocationZoom;
        region.span = span;

        [_mapView setRegion:region animated:YES];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    
    circleSet = YES;
    
    if (shouldHandleLongPress)
    {
        circleRenderer.fillColor = [[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].geofenceCircleColor colorWithAlphaComponent:0.2];
        circleRenderer.lineWidth = 1.0;
    }
    else
    {
        if (!startPinch)
        {
            circleRenderer.fillColor = [[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].geofenceCircleColor colorWithAlphaComponent:0.2];
            circleRenderer.lineWidth = 1.0;
        }
        else
            circleRenderer.lineWidth = 8.0;
    }
    
    circleRenderer.strokeColor = [UIColor blackColor];
    return circleRenderer;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
        [self resetCircle:sender];
}

-(void)resetCircle:(UIGestureRecognizer *)sender
{
    if (circleSet)
    {
        [_mapView removeOverlay:circle];
        [_mapView removeAnnotation:point];
    }
    
    circleSet = YES;
    
    CGPoint touchPoint = [sender locationInView:_mapView];
    
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = touchMapCoordinate;
    [_mapView addAnnotation:point];
    
    float radius = MKMapRectGetWidth(_mapView.visibleMapRect) / MapViewDivisor;
    
    if (radius < (float)kLKGeoFenceMiniumuRadius)
        radius = kLKGeoFenceMiniumuRadius;
    
    geoLatitude = touchMapCoordinate.latitude;
    geoLongitude = touchMapCoordinate.longitude;
    geoRadius = radius;
    
    circle = [MKCircle circleWithCenterCoordinate:touchMapCoordinate radius:radius];
    
    [_mapView addOverlay:circle];
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
                                   if(popView)
                                       [self.navigationController popViewControllerAnimated:NO];
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
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

@end
