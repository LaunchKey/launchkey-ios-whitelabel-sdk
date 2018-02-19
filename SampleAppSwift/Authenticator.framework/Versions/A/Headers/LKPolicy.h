//
//  LKPolicy.h
//  Authenticator
//
//  Created by ani on 11/16/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKPolicy;

@interface LKPolicyByType : NSObject

@property (nonatomic, assign) BOOL knowledge;
@property (nonatomic, assign) BOOL inherence;
@property (nonatomic, assign) BOOL possession;

@end

@interface LKPolicyByCount : NSObject

@property (nonatomic, assign) int countTotal;

@end

@interface LKPolicy : NSObject

@property (nonatomic, assign, readonly) BOOL knowledge;
@property (nonatomic, assign, readonly) BOOL inherence;
@property (nonatomic, assign, readonly) BOOL possession;
@property (nonatomic, assign, readonly) int countTotal;

-(instancetype)initWithTypeBuilder:(LKPolicyByType *)builder;
-(instancetype)initWithCountBuilder:(LKPolicyByCount *)builder;
+(instancetype)makeWithTypeBuilder:(void (^)(LKPolicyByType *))builder;
+(instancetype)makeWithCountBuilder:(void (^)(LKPolicyByCount *))builder;

@end
