//
//  LKWServiceProfile.h
//  WhiteLabel
//
//  Created by ani on 10/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKWServiceProfile : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) NSString *logID;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *context;

@end
