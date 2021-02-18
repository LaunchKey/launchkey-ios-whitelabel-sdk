//
//  LaunchKeyUIBundle.m
//  LaunchKey iOS SDK
//
//  Created by Kristin Tomasik on 1/7/15.
//  Copyright (c) 2015 LaunchKey. All rights reserved.
//

#import "LaunchKeyUIBundle.h"

// NOTICE THIS FILE IS ONLY MEMBER OF AuthenticatorDynamicFramework Target

@implementation NSBundle (LaunchKeyUIAdditions)

+ (NSBundle *)LaunchKeyUIBundle
{
    static NSBundle* UIBundle = nil;
    static dispatch_once_t UIpredicate;
    dispatch_once(&UIpredicate, ^{
        NSString* const UIFrameworkBundleID  = @"com.iovation.Authenticator";
        UIBundle = [NSBundle bundleWithIdentifier:UIFrameworkBundleID];
    });
    
    return UIBundle;
}

@end
