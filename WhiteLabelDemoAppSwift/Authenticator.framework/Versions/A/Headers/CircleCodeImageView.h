//
//  CircleCodeImageView.h
//  WhiteLabel
//
//  Created by ani on 1/25/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleCodeImageView : UIImageView

@property (nonatomic, strong) UIColor *defaultColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *highlightColor UI_APPEARANCE_SELECTOR;

@end
