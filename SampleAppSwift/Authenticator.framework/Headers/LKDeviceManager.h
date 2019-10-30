//
//  LKDeviceManager.h
//  Authenticator
//
//  Created by Steven Gerhard on 8/13/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOADevice.h"


typedef void (^getDevicesCompletion)(NSArray<IOADevice*> *array, NSError *error);

@interface LKDeviceManager : NSObject

/*!
 @brief Use this method to retrieve the list of currently linked devices
 @discussion This method will return an NSArray in the getDevicesCompletion block that represents the list of IOADevice Objects which are the currently linked devices.
 @param block The getDevicesCompletion block that will return an NSArray in the getDevicesCompletion block that represents the list of IOADeviceObjects which are currently linked devices. If there is an error retrieving the list, an NSError object will be returned.
 */
+(void)getDevices:(getDevicesCompletion)block;

/*!
 @brief Use this method to retrieve the current device
 @discussion This method will return the IOADevice object representing the current device.
 @return IOADevice The current IOADevice object representing the current device.
 */
+(IOADevice*)currentDevice;

@end
