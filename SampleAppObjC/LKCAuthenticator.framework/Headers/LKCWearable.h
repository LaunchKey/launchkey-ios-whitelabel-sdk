//
//  LKCWearable.h
//  Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKCWearable : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *timeRemainingUntilAdded;
@property (nonatomic, strong) NSString *timeRemainingUntilRemoved;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL isBeingRemoved;

@end
