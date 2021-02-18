//
//  PinCodeButton.m
//  WhiteLabel
//
//  Created by ani on 11/8/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "PinCodeButton.h"

@implementation PinCodeButton

static BOOL roundedButtons;

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted)
    {
        self.backgroundColor = _highlihgtedStateColor;
    }
    else
    {
        if([PinCodeButton appearance].backgroundColor == nil)
            self.backgroundColor = [UIColor colorWithRed:(232/255.0) green:(232/255.0) blue:(232/255.0) alpha:1.0];
        else
            self.backgroundColor = [PinCodeButton appearance].backgroundColor;
    }
}

-(void)setPinCodeButtonAsCircle:(BOOL)asCircle
{
    roundedButtons = asCircle;
    if(asCircle)
    {
        self.layer.cornerRadius = self.frame.size.height / 2;
        self.layer.masksToBounds = YES;
    }
}

-(void)setBorderColor:(UIColor *)borderColor
{
    if(borderColor)
        self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    if(borderWidth)
        self.layer.borderWidth = borderWidth;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    if (roundedButtons) {
        self.layer.cornerRadius = self.frame.size.height / 2;
        self.layer.masksToBounds = YES;
    }
}

@end
