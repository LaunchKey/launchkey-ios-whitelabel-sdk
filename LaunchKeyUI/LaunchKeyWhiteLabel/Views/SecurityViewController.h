//
//  SecurityViewController.h
//  WhiteLabel
//
//  Created by ani on 4/25/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOALabel.h"

@interface SecurityViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblSecurityFactors;
@property (strong, nonatomic) IBOutlet UIView *securityView;
@property (weak, nonatomic) IBOutlet IOALabel *labelNoAuthMethods;

@end
