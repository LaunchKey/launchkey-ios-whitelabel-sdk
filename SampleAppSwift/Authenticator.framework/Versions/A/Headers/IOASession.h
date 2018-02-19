//
//  IOASession.h
//  WhiteLabel
//
//  Created by ani on 1/13/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOASession : NSObject

@property (nonatomic, strong) NSString *serviceID;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *serviceIcon;
@property (nonatomic, strong) NSDate *dateCreated;

@end
