//
//  DevicesViewController.h
//  WhiteLabel
//
//  Created by ani on 5/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Completion)(NSArray *array, NSError *error);

@interface DevicesViewController : UIViewController

/*!
 @brief Use this method to initialize the view in your parent app with the default Devices View
 @discussion This method will push the default Devices View on to the stack that displays a UITableView of currently linked devices.
 @param parentViewController The current View Controller where you want the default Devices View to be pushed on to.
 */
-(id)initWithParentView:(UIViewController*)parentViewController;
/*!
 @brief Use this method refresh the list of devices in the TableView of the default Devices View
 @discussion This method will refresh the list of devices displayed in the TableView of the default Devices View.
 */
-(void)refreshDevicesView;

@end
