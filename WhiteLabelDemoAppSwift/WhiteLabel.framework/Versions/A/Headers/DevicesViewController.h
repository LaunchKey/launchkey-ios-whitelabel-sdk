//
//  DevicesViewController.h
//  WhiteLabel
//
//  Created by ani on 5/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKWDevice.h"

static const int statusLinking = LKWDeviceStatusLinking; __attribute((deprecated("Use LKWDeviceStatusLinking")))
static const int statusLinked = LKWDeviceStatusLinked; __attribute((deprecated("Use LKWDeviceStatusLinked")))
static const int statusUnlinking = LKWDeviceStatusUnlinking; __attribute((deprecated("Use LKWDeviceStatusUnlinking")))

typedef void (^Completion)(NSArray *array, NSError *error);
typedef void (^getDevicesCompletion)(NSArray<LKWDevice*> *array, NSError *error);

@interface DevicesViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController;

-(void)getDeviceList:(Completion)block __attribute((deprecated("Use -getDevices:")));

-(void)getDevices:(getDevicesCompletion)block;

-(void)refreshDevicesView;

-(NSString*)getCurrentDevice __attribute((deprecated("Use -currentDevice:")));

-(LKWDevice*)currentDevice;

@end
