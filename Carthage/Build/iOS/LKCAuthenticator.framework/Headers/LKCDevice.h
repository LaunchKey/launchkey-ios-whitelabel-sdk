//
//  LKCDevice.h
//  WhiteLabel
//
//  Created by ani on 10/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKCDevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic) BOOL isCurrent;

@end
