//
//  SecurityFactorTableViewCell.h
//  WhiteLabel
//
//  Created by ani on 11/15/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecurityFactorTableViewCell : UITableViewCell

/// This UIImage property is the image of the PIN Code auth method displayed in the Security View. */
@property UIImage *imagePINCodeFactor;
/// This UIImage property is the image of the Circle Code auth method displayed in the Security View. */
@property UIImage *imageCircleCodeFactor;
/// This UIImage property is the image of the Wearables auth method displayed in the Security View. */
@property UIImage *imageBluetoothFactor;
/// This UIImage property is the image of the Locations auth method displayed in the Security View. */
@property UIImage *imageGeofencingFactor;
/// This UIImage property is the image of the Fingerprint Scan auth method displayed in the Security View. */
@property UIImage *imageFingerprintFactor;

@end
