//
//  LKWDevice.h
//  WhiteLabel
//
//  Created by ani on 10/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LKWDeviceStatus)
{
    LKWDeviceStatusLinking = 0,
    LKWDeviceStatusLinked = 1,
    LKWDeviceStatusUnlinking = 2
};

@interface LKWDevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) LKWDeviceStatus status;
@property (nonatomic, strong) NSString *UUID;

-(BOOL)isLinking;
-(BOOL)isLinked;
-(BOOL)isUnlinking;

@end
