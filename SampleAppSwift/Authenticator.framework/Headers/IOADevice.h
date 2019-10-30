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

/*!
 @brief Use this method to determine if the device is in a "Linking" state
 @discussion This method will return if the device is in a "Linking" state.
 @return BOOL The boolean value representing if the device is in a "Linking" state
 */
-(BOOL)isLinking;
/*!
 @brief Use this method to determine if the device is in a "Linked" state
 @discussion This method will return if the device is in a "Linked" state.
 @return BOOL The boolean value representing if the device is in a "Linked" state
 */
-(BOOL)isLinked;
/*!
 @brief Use this method to determine if the device is in a "Unlinking" state
 @discussion This method will return if the device is in a "Unlinking" state.
 @return BOOL The boolean value representing if the device is in a "Unlinking" state
 */
-(BOOL)isUnlinking;

@end
