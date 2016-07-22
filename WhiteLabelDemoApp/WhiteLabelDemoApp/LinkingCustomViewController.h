//
//  LinkingCustomViewController.h
//  WhiteLabelDemoApp
//
//  Created by ani on 7/12/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkingCustomViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfLinkingCode;
@property (weak, nonatomic) IBOutlet UITextField *tfDeviceName;
@property (weak, nonatomic) IBOutlet UISwitch *switchDeviceName;
@property (weak, nonatomic) IBOutlet UIButton *btnLink;

@end
