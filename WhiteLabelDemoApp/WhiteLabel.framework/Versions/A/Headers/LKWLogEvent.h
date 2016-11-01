//
//  LKWLogEvent.h
//  WhiteLabel
//
//  Created by ani on 10/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKWLogEvent : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appIcon;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *dateUpdated;
@property (nonatomic, strong) NSString *context;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *state;

@end
