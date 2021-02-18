//
//  AuthRequestContainer.h
//  WhiteLabel
//
//  Created by ani on 11/16/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthRequestContainer : UIView

/// This UIImage property is used to override the default image that's displayed during an Auth Request when verifying Wearables. */
@property UIImage *imageAuthRequestBluetooth;
/// This UIImage property is used to override the default image that's displayed during an Auth Request when verifying Locations. */
@property UIImage *imageAuthRequestGeofence;

@end
