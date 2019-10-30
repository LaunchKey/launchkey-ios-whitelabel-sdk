//
//  AuthResponseNegativeButton.h
//  Authenticator
//
//  Created by ani on 12/6/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthResponseNegativeButton : UIButton

/// This UIColor property is the color that fills the Deny and Submit buttons when pressing and holding. */
@property (nonatomic, strong) UIColor *fillColor UI_APPEARANCE_SELECTOR;
/// This UIColor property is the color of the text of the Deny and Submit buttons. */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

@end
