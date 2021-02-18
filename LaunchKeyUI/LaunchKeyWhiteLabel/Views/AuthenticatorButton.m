//
//  AuthenticatorButton.m
//  WhiteLabel
//
//  Created by ani on 11/10/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "AuthenticatorButton.h"

@implementation AuthenticatorButton

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}

@end
