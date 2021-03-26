//
//  LKCVerificationFlag.h
//  LKCAuthenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum state {ALWAYS, WHENREQUIRED} FlagState;

@interface LKCVerificationFlag : NSObject

@property (nonatomic) FlagState state;
@property (nonatomic) BOOL pendingSwitch;
@property (nonatomic) NSString *timeRemainingUntilFlagIsChanged;

@end
