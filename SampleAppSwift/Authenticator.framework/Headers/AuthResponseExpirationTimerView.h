//
//  AuthResponseExpirationTimerView.h
//  Authenticator
//
//  Created by ani on 12/6/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthResponseExpirationTimerView : UIView

/// This UIColor property is the color that fills the Expiration Timer displayed during an Auth Request. */
@property (nonatomic, strong) UIColor *fillColor UI_APPEARANCE_SELECTOR;
/// This UIColor property is the color that fills the Expiration Timer displayed during an Auth Request, during the last 10 seconds. */
@property (nonatomic, strong) UIColor *warningColor UI_APPEARANCE_SELECTOR;

@end
