//
//  SecurityBluetoothViewController.h
//  LaunchKey
//
//  Created by ani on 12/15/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class SecurityBluetoothViewController;

@protocol SecurityBluetoothViewControllerDelegate <NSObject>

-(void)bluetoothAdded:(SecurityBluetoothViewController *)controller;

@end

@interface SecurityBluetoothViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <SecurityBluetoothViewControllerDelegate> delegate;
@property BOOL fromAdd;
@property (weak, nonatomic) IBOutlet UITableView *tblDevices;
@end
