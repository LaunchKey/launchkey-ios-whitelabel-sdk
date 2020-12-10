//
//  ObjCCatchException.h
//  SampleAppSwift
//
//  Created by Steven Gerhard on 10/22/20.
//  Copyright © 2020 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjCCatchException : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
