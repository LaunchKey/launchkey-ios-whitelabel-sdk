//
//  IOADevice.h
//  WhiteLabel
//
//  Created by ani on 10/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IOADeviceStatus)
{
    IOADeviceStatusLinking = 0,
    IOADeviceStatusLinked = 1,
    IOADeviceStatusUnlinking = 2
};

@interface IOADevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) IOADeviceStatus status;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *type;

-(BOOL)isLinking;
-(BOOL)isLinked;
-(BOOL)isUnlinking;

@end
