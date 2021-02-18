//
//  SecurityGeofenceViewController.h
//  LaunchKey
//
//  Created by ani on 12/15/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SecurityViewController.h"

@class SecurityGeofenceViewController;

@protocol SecurityGeofenceViewControllerDelegate <NSObject>

-(void)geofenceAdded:(SecurityGeofenceViewController *)controller;

@end

@interface SecurityGeofenceViewController : UIViewController

@property BOOL fromAdd;
@property BOOL fromSettings;
@property (nonatomic, weak) id <SecurityGeofenceViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
