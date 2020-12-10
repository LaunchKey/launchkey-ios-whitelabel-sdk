//
//  LKCAPISessionMetrics.h
//  Authenticator
//
//  Created by Steven Gerhard on 12/5/19.
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

// Encapsulates metric data that is returned on completion of a LKHTTPSessionManager network request
@interface LKCAPISessionMetrics : NSObject

@property int metricRead;
@property int metricWrite;
@property int metricEncryption;
@property int metricDecryption;
@property int metricDuration;
@property BOOL metricSuccess;
@property (strong, nonatomic) NSString* metricStatusCode;
@property (strong, nonatomic) NSString* metricErrorMessage;
@property (strong, nonatomic) NSString* metricErrorCode;
@property (strong, nonatomic) NSString* metricNetworkType;
@property (strong, nonatomic) NSString* metricOperatorName;
@property (strong, nonatomic) NSString* metricJTI;

@end
