//
//  PinCodeButton.h
//  WhiteLabel
//
//  Created by ani on 11/8/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinCodeButton : UIButton

/// This UIColor property is the color of the buttons in the PIN Code widget when tapped on. */
@property (nonatomic, strong) UIColor *highlihgtedStateColor UI_APPEARANCE_SELECTOR;
/// This UIColor property is the text color of the letters in the buttons of the PIN Code widget. */
@property (nonatomic, strong) UIColor *lettersColor UI_APPEARANCE_SELECTOR;
/// This UIColor property is the bullet color when an End User inputs their PIN Code. */
@property (nonatomic, strong) UIColor *bulletColor UI_APPEARANCE_SELECTOR;

/*!
 @brief Use this method to set the shape of the buttons in the PIN Code widget
 @discussion This method will set the shape of the buttons in the PIN Code widget as either a circle (pass YES/true) or square (pass NO/false).
 @param asCircle BOOL value representing if the shape of the buttons in the PIN Code widget should be a circle (YES/true) or square (NO/false).
 */
-(void)setPinCodeButtonAsCircle:(BOOL)asCircle;
/*!
 @brief Use this method to set the border color of the buttons in the PIN Code widget
 @discussion This method will set the border color of the buttons in the PIN Code widget.
 @param borderColor UIColor used to set the border color of the buttons in the PIN Code widget.
 */
-(void)setBorderColor:(UIColor*)borderColor;
/*!
 @brief Use this method to set the border width of the buttons in the PIN Code widget
 @discussion This method will set the border width of the buttons in the PIN Code widget.
 @param borderWidth CGFloat used to set the border width of the buttons in the PIN Code widget.
 */
-(void)setBorderWidth:(CGFloat)borderWidth;

@end
