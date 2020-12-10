//
//  LKCHTTPSessionManager.h
//  LaunchKey
//
//  Created by Steven Gerhard on 11/12/19.
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "LKCAPIRequestSpecs.h"
#import "LKCAPISessionMetrics.h"

typedef void (^LKAPISuccess)(NSURLSessionDataTask *task, id responseObject, LKCAPISessionMetrics *metrics);
typedef void (^LKAPIFailure)(NSURLSessionDataTask *task, NSError *error, id responseObject, LKCAPISessionMetrics *metrics);

// Wraps AFNetworking's AFHTTPSessionManager with LaunchKey's custom logic
@interface LKCHTTPSessionManager : AFHTTPSessionManager
///---------------------------
/// @name Making HTTP Requests
///---------------------------
#pragma mark - v3APICAll
- (NSURLSessionDataTask *)v3APICall:(NSString*)type
                             method:(NSString*)method
                           resource:(NSString*)resource
                         requestSpecs:(LKCAPIRequestSpecs*)specs
                           endpoint:(NSString*)endpoint
                            success:(LKAPISuccess)success
                            failure:(LKAPIFailure)failure;
@end
