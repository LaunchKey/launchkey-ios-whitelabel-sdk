//
//  LKUIStringVerification.h
//  LaunchKey UI
//
//  Created by Steven Gerhard on 2/26/2020.
//  Copyright (c) 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AuthMethodWidgetState) {
    calledFromAdd,
    calledFromRemove,
    calledFromVerify,
    calledFromAuthRequest,
};

@interface LKUIStringVerification : NSObject

+(BOOL)stringContainsEmoji:(NSString *)string;
+(BOOL)isInValidEntry:(NSString *)string;
+(NSString *)platformString;
+(NSString *)getEscapedString:(NSString *)path;
+(BOOL)isDeviceNameValid:(NSString *)deviceName;
+(NSString *)cleanUpDeviceName:(NSString *)deviceName;

@end
