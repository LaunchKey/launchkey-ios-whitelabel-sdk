//
//  IOASession.h
//  WhiteLabel
//
//  Created by ani on 1/13/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOASession : NSObject

/// This NSString property is the ID of the service. */
@property (nonatomic, strong) NSString *serviceID;
/// This NSString property is the name of the service */
@property (nonatomic, strong) NSString *serviceName;
/// This NSString property is the URL string associated with the service icon. */
@property (nonatomic, strong) NSString *serviceIcon;
/// This NSDate is the date of when the session was created. */
@property (nonatomic, strong) NSDate *dateCreated;

@end
