//
//  GeofenceWidgetViewController.m
//  LaunchKey
//
//  Created by ani on 12/22/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "GeofenceWidgetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthRequestContainer.h"
#import "LKUIConstants.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCGeofenceManager.h>

@interface GeofenceWidgetViewController ()
{
    BOOL checkComplete;
}
@end

@implementation GeofenceWidgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([AuthRequestContainer appearance].imageAuthRequestGeofence != nil)
        [_imageFactor setImage:[AuthRequestContainer appearance].imageAuthRequestGeofence];
    else
    {
        NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
        UIImage *image = [UIImage imageNamed:@"ic_place_48pt_2x" inBundle:bundle compatibleWithTraitCollection:nil];
        [_imageFactor setImage:image];
    }
    
    [self runSpinAnimationWithDuration:100.0];
    
    checkComplete = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self startLookingForGeofence];
    });
}

-(void)viewDidDisappear:(BOOL)animated
{
   // Ensure geo-fence check is stopped if Auth Request View is left and check isn't complete
    if(!checkComplete)
    {
        [LKCGeofenceManager stopGeofencesScanning];
        checkComplete = YES;
    }
}

#pragma mark - Start Geo-Fence Scan
-(void)startLookingForGeofence
{
    [LKCGeofenceManager verifyGeofencesForAuthRequest:_authRequestDetails withCompletion:^(BOOL sucess, NSError *error) {
        if(sucess)
        {
           if(!checkComplete)
           {
               checkComplete = YES;
               [self geofenceComplete];
           }
        }
        else
        {
            // GeoFence invalid
            if(!checkComplete)
            {
                checkComplete = YES;
                if([error.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"Orbit_Location_Off", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
                    [self.delegate geofenceVerified:self geofenceVerified:NO withAuthResponseReason:PERMISSION];
                else if([error.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"Orbit_Location_Services_Off", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
                    [self.delegate geofenceVerified:self geofenceVerified:NO withAuthResponseReason:SENSOR];
                else
                    [self.delegate geofenceVerified:self geofenceVerified:NO withAuthResponseReason:AUTHENTICATION];
            }
        }
    }];
}

-(void)geofenceComplete
{
    // Geofence Check Complete
    [self.delegate geofenceVerified:self geofenceVerified:YES withAuthResponseReason:APPROVED];
}

#pragma mark - Animation Methods
- (void) runSpinAnimationWithDuration:(CGFloat) duration;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 1 * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.speed = 0.10;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1.0;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [_imgBorder.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
