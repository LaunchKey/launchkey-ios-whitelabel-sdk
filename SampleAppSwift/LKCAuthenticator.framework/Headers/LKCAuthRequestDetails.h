//
//  LKCAuthRequestDetails.h
//  AuthenticatorDynamicFramework
//
//  Created by Steven Gerhard on 1/31/20.
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

// Public object shared with implementors to represent an AuthRequest
@interface LKCAuthRequestDetails : NSObject

@property(strong, nonatomic) NSString *authRequestID;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *serviceID;
@property(strong, nonatomic) NSString *expiresAtTime;
@property(strong, nonatomic) NSString *createdAtTime;
@property(strong, nonatomic) NSString *context;
@property(strong, nonatomic) NSString *serviceIcon;
@property(strong, nonatomic) NSArray *denialReasons;

@end
