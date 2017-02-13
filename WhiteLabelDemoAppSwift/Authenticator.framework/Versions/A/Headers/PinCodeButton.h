//
//  PinCodeButton.h
//  WhiteLabel
//
//  Created by ani on 11/8/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinCodeButton : UIButton

@property (nonatomic, strong) UIColor *highlihgtedStateColor UI_APPEARANCE_SELECTOR;

-(void)setPinCodeButtonAsCircle:(BOOL)asCircle;

@end