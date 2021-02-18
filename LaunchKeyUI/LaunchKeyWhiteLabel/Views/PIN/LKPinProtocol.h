//
//  LKPinProtocol.h
//  LaunchKey
//
//  Created by Kristin Tomasik on 2/26/14.
//  Copyright (c) 2014 LaunchKey, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKPinProtocol.h"

@protocol LKPinProtocol <NSObject>

- (void) pinIsValidProtocol:(NSString*)token;

@end
