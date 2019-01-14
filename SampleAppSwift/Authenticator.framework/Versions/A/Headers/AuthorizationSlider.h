//
//  AuthorizationSlider.h
//  WhiteLabel
//
//  Created by ani on 1/23/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationSlider : UIImageView

@property (nonatomic, strong) UIColor *topColor UI_APPEARANCE_SELECTOR __attribute((deprecated("The Auth Request UI has been updated and the Authorization Slider no longer exists. This property will be removed in the next major release.")));
@property (nonatomic, strong) UIColor *bottomColor UI_APPEARANCE_SELECTOR __attribute((deprecated("The Auth Request UI has been updated and the Authorization Slider no longer exists. This property will be removed in the next major release.")));

@end
