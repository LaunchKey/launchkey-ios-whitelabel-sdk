//
//  CircleCodeImageView.h
//  WhiteLabel
//
//  Created by ani on 1/25/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleCodeImageView : UIImageView

/// This UIColor property is the default color of the Circle Code center and hashmarks. */
@property (nonatomic, strong) UIColor *defaultColor UI_APPEARANCE_SELECTOR;
/// This UIColor property is the highlight color of the Circle Code center and hashmarks when pressed. */
@property (nonatomic, strong) UIColor *highlightColor UI_APPEARANCE_SELECTOR;

@end
