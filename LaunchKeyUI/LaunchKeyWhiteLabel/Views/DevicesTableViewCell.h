//
//  DevicesTableViewCell.h
//  WhiteLabel
//
//  Created by ani on 5/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticatorButton.h"

@interface DevicesTableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelDeviceName;
@property (unsafe_unretained, nonatomic) IBOutlet AuthenticatorButton *btnUnlink;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentDevice;

@end
