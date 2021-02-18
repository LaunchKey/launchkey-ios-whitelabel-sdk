//
//  LKUIStringVerification.m
//  LaunchKey UI
//
//  Created by Steven Gerhard on 2/26/2020.
//  Copyright (c) 2020 TransUnion. All rights reserved.
//

#import "LKUIStringVerification.h"
#import <sys/utsname.h>

@implementation LKUIStringVerification


+(BOOL)isInValidEntry:(NSString *)string
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[<>;@]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSString *result = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    
    if ([result length] != [string length]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

// IS DUPLICATE IMPLEMENTATION see LKStringVerification and update together
+(NSString *)platformString
{
    struct utsname systemInfoName;
    uname(&systemInfoName);
    
    NSString *platform = [NSString stringWithCString:systemInfoName.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])    return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2G";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}
// IS DUPLICATE implementaiton see LKStringVerification and update together
+(NSString*)getEscapedString:(NSString*)path
{
    if([path isEqualToString:@""]) {
        return @"dsfnaa92hsfnpaiwh93t4";
    }
    else {
        NSCharacterSet *characterSet = [NSCharacterSet
                                       characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
        NSString *escapedUrlString = [path stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
        return escapedUrlString;
    }
}

// IS DUPLICATE implementaiton see LKStringVerification and update together
+(BOOL)isDeviceNameValid:(NSString *)deviceName
{
    int device_name_max = 46;
    if([deviceName length] > device_name_max)
    {
        return NO;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9.,\\s'-/!_@ ]{1,}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSString *result = [regex stringByReplacingMatchesInString:deviceName options:0 range:NSMakeRange(0, [deviceName length]) withTemplate:@""];
    
    if ([result length] != [deviceName length]) {
        return YES;
    }
    else {
        return NO;
    }
}

// IS DUPLICATE implementaiton see LKStringVerification and update together
+(NSString*)cleanUpDeviceName:(NSString *)deviceName
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[.,\\s'-/!_@]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    if(deviceName == NULL || [deviceName isEqualToString:@""])
    {
        return @"";
    }
    
    NSString *result = [regex stringByReplacingMatchesInString:deviceName options:0 range:NSMakeRange(0, [deviceName length]) withTemplate:@""];
    
    if(result == NULL || [result isEqualToString:@""])
    {
        return @"";
    }
    
    int device_name_max = 46;

    if(result != NULL && [result length] > device_name_max)
    {
        result = [result substringToIndex:device_name_max];
    }
    
    // Fix for fancy iOS keyboard apostrophe
    result = [result stringByReplacingOccurrencesOfString:@"’" withString:@"'"];
    
    return result;
}

@end
