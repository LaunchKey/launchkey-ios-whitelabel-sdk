//
//  APICallManager.h
//  Authenticator
//
//  Created by ani on 6/30/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APICompletion)(NSDictionary *responseObject, NSError *error);

@interface APICallManager : NSObject

+(APICallManager*)sharedManager;

// API Call
-(void)APIWithType:(NSString *)type method:(NSString *)method resource:(NSString *)resource body:(NSMutableDictionary *)body endpoint:(NSString *)endpoint params:(NSMutableDictionary*)params withCompletion:(APICompletion)completion;

@end
