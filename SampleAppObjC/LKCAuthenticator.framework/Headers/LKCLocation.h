//
//  LKCLocation.h
//  Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKCLocation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *radius;
@property (nonatomic, strong) NSString *timeRemainingUntilAdded;
@property (nonatomic, strong) NSString *timeRemainingUntilRemoved;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL isBeingRemoved;

@end
