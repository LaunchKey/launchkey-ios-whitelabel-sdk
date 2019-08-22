//
//  AuthenticatorButton.h
//  WhiteLabel
//
//  Created by ani on 11/10/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticatorButton : UIButton

/// This UIColor property is used to set the text color of the AuthenticatorButton when it is tied to a "negative" action such as unlinking. */
@property (nonatomic, strong) UIColor *negativeActionTextColor UI_APPEARANCE_SELECTOR;
/// This UIColor property is used to set the background color of the AuthenticatorButton when it is tied to a "negative" action such as unlinking. */
@property (nonatomic, strong) UIColor *negativeActionBackgroundColor UI_APPEARANCE_SELECTOR;

@end
