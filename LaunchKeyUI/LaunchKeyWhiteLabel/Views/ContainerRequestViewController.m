//
//  ContainerRequestViewController.m
//  WhiteLabel
//
//  Created by ani on 4/21/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "ContainerRequestViewController.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "PINCodeViewController.h"
#import "LocationsWidgetViewController.h"
#import "GeofenceWidgetViewController.h"
#import "BluetoothWidgetViewController.h"
#import "FingerprintWidgetViewController.h"
#import "CircleCodeViewControllerWidgetViewController.h"
#import "LKUIConstants.h"
#import <LKCAuthenticator/LKCFaceScanManager.h>
#import "LKUIStringVerification.h"

@interface ContainerRequestViewController () <PINCodeViewControllerDelegate, LocationsWidgetDelegate, GeofenceWidgetDelegate, BluetoothWidgetDelegate, FingerprintWidgetDelegate, CircleCodeViewControllerDelegate>
@end

@implementation ContainerRequestViewController
{
    NSString *instructionLabel;
    int numberPresented;
}

@synthesize isPINEnabled, isCircleCodeEnabled, isBluetoothEnabled, isGeofenceEnabled, isLocationsEnabled, isFingerprintEnabled;
@synthesize numberOfFactors;

- (void)viewDidLoad
{
    [super viewDidLoad];

    numberPresented = 0;
    
    if(isBluetoothEnabled)
    {
        [self displayWearablesCheck];
    }
    else if(isGeofenceEnabled)
    {
        [self displayGeofenceCheck];
    }
    else if(isLocationsEnabled)
    {
        [self displayLocationsCheck];
    }
    else if (isPINEnabled)
    {
        [self displayPINCodeCheck];
    }
    else if(isCircleCodeEnabled)
    {
        [self displayCircleCodeCheck];
    }
    else if(isFingerprintEnabled)
    {
        [self displayFingerprintCheck];
    }
}

#pragma mark - Bluetooth Verified
-(void)BluetoothVerified:(BluetoothWidgetViewController *)controller BluetoothVerified:(BOOL)BluetoothValid withReason:(AuthResponseReason)reason
{
    if(!BluetoothValid)
    {
        [self.delegateContainer denyRequestFromContainer:self withAuthReason:reason forAuthMethod:WEARABLES];
    }
    else
    {        
        if(isGeofenceEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayGeofenceCheck];
            });
        }
        else if(isLocationsEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayLocationsCheck];
            });
        }
        else if(isPINEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayPINCodeCheck];
            });
        }
        else if(isCircleCodeEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayCircleCodeCheck];
            });
        }
        else if (isFingerprintEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayFingerprintCheck];
            });
        }
        else
        {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.delegateContainer authorizeRequestFromContainer:self withToken:[LKUIStringVerification getEscapedString:@""]];
            });
        }
    }
}

#pragma mark - Geofence Verified
-(void)geofenceVerified:(GeofenceWidgetViewController *)controller geofenceVerified:(BOOL)geofenceValid withAuthResponseReason:(AuthResponseReason)reason;
{
    if(!geofenceValid)
    {
        [self.delegateContainer denyRequestFromContainer:self withAuthReason:reason forAuthMethod:GEOFENCING];
    }
    else
    {        
        if(isLocationsEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                numberPresented --;
                [self displayLocationsCheck];
            });
        }
        else if(isPINEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayPINCodeCheck];
            });
            
        }
        else if(isCircleCodeEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayCircleCodeCheck];
            });
        }
        else if (isFingerprintEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayFingerprintCheck];
            });
        }
        else
        {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.delegateContainer authorizeRequestFromContainer:self withToken:[LKUIStringVerification getEscapedString:@""]];
            });
        }
    }
}

#pragma mark - Locations Verified
-(void)locationsVerified:(GeofenceWidgetViewController *)controller locationVerified:(BOOL)locationValid withAuthResponseReason:(AuthResponseReason)reason
{
    if(!locationValid)
    {
        [self.delegateContainer denyRequestFromContainer:self withAuthReason:reason forAuthMethod:LOCATIONS];
    }
    else
    {        
        if(isPINEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayPINCodeCheck];
            });
            
        }
        else if(isCircleCodeEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayCircleCodeCheck];
            });
        }
        else if (isFingerprintEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayFingerprintCheck];
            });
        }
        else
        {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.delegateContainer authorizeRequestFromContainer:self withToken:[LKUIStringVerification getEscapedString:@""]];
            });
        }
    }
}

#pragma mark - PIN Code Verified
-(void)PINVerified:(PINCodeViewController *)controller PINIsVerified:(BOOL)validPIN
{
    if(validPIN)
    {
        if(isCircleCodeEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayCircleCodeCheck];
            });
        }
        else if(isFingerprintEnabled)
        {
            [self displayFingerprintCheck];
        }
        else
        {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.delegateContainer authorizeRequestFromContainer:self withToken:[LKUIStringVerification getEscapedString:@""]];
            });
        }
    }
    else
    {
        [self.delegateContainer denyRequestFromContainer:self withAuthReason:AUTHENTICATION forAuthMethod:PINCODE];
    }
}

#pragma mark - Circle Code Verified
-(void)CircleCodeVerified:(CircleCodeViewControllerWidgetViewController *)controller CircleCodeIsVerfied:(BOOL)validCircleCode
{
    if(validCircleCode)
    {
        if (isFingerprintEnabled)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self displayFingerprintCheck];
            });
        }
        else
        {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.delegateContainer authorizeRequestFromContainer:self withToken:[LKUIStringVerification getEscapedString:@""]];
            });
        }
    }
    else
    {
        [self.delegateContainer denyRequestFromContainer:self withAuthReason:AUTHENTICATION forAuthMethod:CIRCLECODE];
    }
}

#pragma mark - Fingerprint Verified
-(void)FingerprintVerified:(FingerprintWidgetViewController *)controller FingerprintVerified:(BOOL)FingerprintValid withAuthReason:(AuthResponseReason)reason
{
    if(FingerprintValid)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegateContainer authorizeRequestFromContainer:self withToken:[LKUIStringVerification getEscapedString:@""]];
        });
    }
    else
    {
        if([LKCFaceScanManager isFaceIDAvailable])
        {
            [self.delegateContainer denyRequestFromContainer:self withAuthReason:reason forAuthMethod:FACESCAN];
        }
        else
        {
            [self.delegateContainer denyRequestFromContainer:self withAuthReason:reason forAuthMethod:FINGERPRINTSCAN];
        }
    }
}

#pragma mark - Go To Widget Helper Methods
-(void)displayWearablesCheck
{
    numberPresented++;
    instructionLabel = kLKWearables;
    [self performSegueWithIdentifier:@"toBluetoothWidgetViewController" sender:self];
    [self.delegateContainer updateInstructionLabel:self updateLabel:instructionLabel updateNumber:numberPresented totalNumber:numberOfFactors];
}

-(void)displayGeofenceCheck
{
    numberPresented++;
    instructionLabel = kLKGeofences;
    [self performSegueWithIdentifier:@"toGeofenceWidgetViewController" sender:self];
    [self.delegateContainer updateInstructionLabel:self updateLabel:instructionLabel updateNumber:numberPresented totalNumber:numberOfFactors];
}

-(void)displayLocationsCheck
{
    numberPresented++;
    instructionLabel = kLKLocations;
    [self performSegueWithIdentifier:@"toLocationsWidgetViewController" sender:self];
    [self.delegateContainer updateInstructionLabel:self updateLabel:instructionLabel updateNumber:numberPresented totalNumber:numberOfFactors];
}

-(void)displayPINCodeCheck
{
    numberPresented++;
    instructionLabel = kLKPINCode;
    [self performSegueWithIdentifier:@"toPINCodeViewControllerfromRequest" sender:self];
    [self.delegateContainer updateInstructionLabel:self updateLabel:instructionLabel updateNumber:numberPresented totalNumber:numberOfFactors];
}

-(void)displayCircleCodeCheck
{
    numberPresented++;
    instructionLabel = kLKCircleCode;
    [self performSegueWithIdentifier:@"toCircleCodeViewControllerfromRequest" sender:self];
    [self.delegateContainer updateInstructionLabel:self updateLabel:instructionLabel updateNumber:numberPresented totalNumber:numberOfFactors];
}

-(void)displayFingerprintCheck
{
    numberPresented++;
    instructionLabel = kLKFingerprintScan;
    [self performSegueWithIdentifier:@"toFingerprintWidgetViewController" sender:self];
    [self.delegateContainer updateInstructionLabel:self updateLabel:instructionLabel updateNumber:numberPresented totalNumber:numberOfFactors];
}

#pragma mark - Prepare For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toBluetoothWidgetViewController"])
    {
        if (self.childViewControllers.count > 0)
        {
            BluetoothWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.authRequestDetails = _authRequestDetails;
            embd.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [[self.childViewControllers objectAtIndex:0]  willMoveToParentViewController:nil];
            [self addChildViewController:embd];
            [self transitionFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:embd duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
                [[self.childViewControllers objectAtIndex:0] removeFromParentViewController];
                [embd didMoveToParentViewController:self];
            }];
        }
        else
        {
            BluetoothWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.authRequestDetails = _authRequestDetails;
            [self addChildViewController:embd];
            UIView* destView = ((UIViewController *)embd).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [embd didMoveToParentViewController:self];
        }
        
    }
    else if([segue.identifier isEqualToString:@"toLocationsWidgetViewController"])
    {
        if (self.childViewControllers.count > 0)
        {
            LocationsWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.authRequestDetails = _authRequestDetails;
            embd.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [[self.childViewControllers objectAtIndex:0]  willMoveToParentViewController:nil];
            [self addChildViewController:embd];
            [self transitionFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:embd duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
                [[self.childViewControllers objectAtIndex:0] removeFromParentViewController];
                [embd didMoveToParentViewController:self];
            }];
        }
        else
        {
            LocationsWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.authRequestDetails = _authRequestDetails;
            [self addChildViewController:embd];
            UIView* destView = ((UIViewController *)embd).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [embd didMoveToParentViewController:self];
        }
    }
    else if([segue.identifier isEqualToString:@"toGeofenceWidgetViewController"])
    {
        if (self.childViewControllers.count > 0)
        {
            GeofenceWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.authRequestDetails = _authRequestDetails;
            embd.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [[self.childViewControllers objectAtIndex:0]  willMoveToParentViewController:nil];
            [self addChildViewController:embd];
            [self transitionFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:embd duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
                [[self.childViewControllers objectAtIndex:0] removeFromParentViewController];
                [embd didMoveToParentViewController:self];
            }];
        }
        else
        {
            GeofenceWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.authRequestDetails = _authRequestDetails;
            [self addChildViewController:embd];
            UIView* destView = ((UIViewController *)embd).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [embd didMoveToParentViewController:self];
        }
    }
    else if([segue.identifier isEqualToString:@"toCircleCodeViewControllerfromRequest"])
    {
        if (self.childViewControllers.count > 0)
        {
            CircleCodeViewControllerWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.state = calledFromAuthRequest;
            embd.authRequestDetails = _authRequestDetails;
            embd.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [[self.childViewControllers objectAtIndex:0]  willMoveToParentViewController:nil];
            [self addChildViewController:embd];
            [self transitionFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:embd duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
                [[self.childViewControllers objectAtIndex:0] removeFromParentViewController];
                [embd didMoveToParentViewController:self];
            }];
        }
        else
        {
            CircleCodeViewControllerWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.state = calledFromAuthRequest;
            embd.authRequestDetails = _authRequestDetails;
            [self addChildViewController:embd];
            UIView* destView = ((UIViewController *)embd).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [embd didMoveToParentViewController:self];
        }
    }
    
    else if([segue.identifier isEqualToString:@"toPINCodeViewControllerfromRequest"])
    {
        if (self.childViewControllers.count > 0)
        {
            PINCodeViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.state = calledFromAuthRequest;
            embd.authRequestDetails = _authRequestDetails;
            embd.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [[self.childViewControllers objectAtIndex:0]  willMoveToParentViewController:nil];
            [self addChildViewController:embd];
            [self transitionFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:embd duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
                [[self.childViewControllers objectAtIndex:0] removeFromParentViewController];
                [embd didMoveToParentViewController:self];
            }];
        }
        else
        {
            PINCodeViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.state = calledFromAuthRequest;
            embd.authRequestDetails = _authRequestDetails;
            [self addChildViewController:embd];
            UIView* destView = ((UIViewController *)embd).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [embd didMoveToParentViewController:self];
        }
    }
    else if([segue.identifier isEqualToString:@"toFingerprintWidgetViewController"])
    {
        if (self.childViewControllers.count > 0)
        {
            FingerprintWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.authRequestDetails = _authRequestDetails;
            embd.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [[self.childViewControllers objectAtIndex:0]  willMoveToParentViewController:nil];
            [self addChildViewController:embd];
            [self transitionFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:embd duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
                [[self.childViewControllers objectAtIndex:0] removeFromParentViewController];
                [embd didMoveToParentViewController:self];
            }];
        }
        else
        {
            FingerprintWidgetViewController *embd = segue.destinationViewController;
            embd.delegate = self;
            embd.authRequestDetails = _authRequestDetails;
            [self addChildViewController:embd];
            UIView* destView = ((UIViewController *)embd).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [embd didMoveToParentViewController:self];
        }
    }
}

@end
