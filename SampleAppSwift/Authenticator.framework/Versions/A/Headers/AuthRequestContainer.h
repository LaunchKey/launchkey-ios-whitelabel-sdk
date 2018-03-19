//
//  AuthRequestContainer.h
//  WhiteLabel
//
//  Created by ani on 11/16/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthRequestContainer : UIView

@property UIImage *imageAuthRequestBluetooth;
@property UIImage *imageAuthRequestGeofence;
@property UIImage *imageAuthRequestFingerprint __attribute((deprecated("The Auth Request UI has been updated so the ability to set the image of the Fingerprint factor no longer exists. This property will be removed in the next major release.")));

@end
