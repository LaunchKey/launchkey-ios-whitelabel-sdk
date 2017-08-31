//
//  DevicesViewController.h
//  WhiteLabel
//
//  Created by ani on 5/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOADevice.h"

typedef void (^Completion)(NSArray *array, NSError *error);
typedef void (^getDevicesCompletion)(NSArray<IOADevice*> *array, NSError *error);

@interface DevicesViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController;

-(void)getDevices:(getDevicesCompletion)block;

-(void)refreshDevicesView;

-(IOADevice*)currentDevice;

-(NSString*)getCurrentDevicePublicKey;

@end
