//
//  ObjCCatchException.m
//  SampleAppSwift
//
//  Created by Steven Gerhard on 10/22/20.
//  Copyright © 2020 LaunchKey. All rights reserved.
//

#import "ObjCCatchException.h"

@implementation ObjCCatchException

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

@end
