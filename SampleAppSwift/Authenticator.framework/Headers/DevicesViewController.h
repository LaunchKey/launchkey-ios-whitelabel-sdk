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

/*!
 @brief Use this method to initialize the view in your parent app with the default Devices View
 @discussion This method will push the default Devices View on to the stack that displays a UITableView of currently linked devices.
 @param parentViewController The current View Controller where you want the default Devices View to be pushed on to.
 */
-(id)initWithParentView:(UIViewController*)parentViewController;
/*!
 @brief Use this method to retrieve the list of currently linked devices
 @discussion This method will return an NSArray in the getDevicesCompletion block that represents the list of IOADevice Objects which are the currently linked devices.
 @param block The getDevicesCompletion block that will return an NSArray in the getDevicesCompletion block that represents the list of IOADeviceObjects which are currently linked devices. If there is an error retrieving the list, an NSError object will be returned.
 */
-(void)getDevices:(getDevicesCompletion)block __attribute((deprecated("DevicesViewController.getDevices is being deprecated. Use LKDeviceManager.getDevices instead")));
/*!
 @brief Use this method refresh the list of devices in the TableView of the default Devices View
 @discussion This method will refresh the list of devices displayed in the TableView of the default Devices View.
 */
-(void)refreshDevicesView;
/*!
 @brief Use this method to retrieve the current device
 @discussion This method will return the IOADevice object representing the current device.
 @return IOADevice The current IOADevice object representing the current device.
 */
-(IOADevice*)currentDevice __attribute((deprecated("DevicesViewController.currentDevice is being deprecated. Use LKDeviceManager.currentDevice instead")));
/*!
 @brief Use this method to retrieve the Public Key of the current device
 @discussion This method will return the Public Key of the current device as a NSString.
 @return NSString The NSString representing the Public Key of the current device.
 */
-(NSString*)getCurrentDevicePublicKey;

@end
