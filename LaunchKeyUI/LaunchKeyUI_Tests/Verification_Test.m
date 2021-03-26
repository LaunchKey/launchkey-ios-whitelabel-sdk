//
//  Verification_Test.m
//  WhiteLabel
//
//  Created by Kristin Tomasik on 2/11/15.
//  Copyright (c) 2015 LaunchKey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "LKUIStringVerification.h"

@interface Verification_Test : XCTestCase {
    NSString * DEVICE_VALID1;
    NSString * DEVICE_VALID2;
    NSString * DEVICE_VALID3;
    NSString * DEVICE_VALID4;
    NSString * DEVICE_VALID5;
    NSString * DEVICE_VALID6;
    NSString * DEVICE_INVALID_EMOJI;
    NSString * DEVICE_INVALID_EMOJI_CLEANED;
}

@end

@implementation Verification_Test

-(void)setUp {
    [super setUp];

     DEVICE_VALID1 = @"A";
     DEVICE_VALID2 = @"Android Device";
     DEVICE_VALID3 = @"Android's Great_Device";
     DEVICE_VALID4 = @"andr01d'z-deV!";
     DEVICE_VALID5 = @"This is a very long string of exactly 46 chars";
     DEVICE_VALID6 = @"String/-with_1'lots of spec,   .char!";
     DEVICE_INVALID_EMOJI = @"Emojii\U0001F431";
     DEVICE_INVALID_EMOJI_CLEANED = @"Emojii";
}

-(void)testIsValidEntry
{
    BOOL result = [LKUIStringVerification isInValidEntry:@"test"];
    
    if (result)XCTFail(@"Entry should be valid");
}

-(void)testIsValidEntryInvalidData
{
    BOOL result = [LKUIStringVerification isInValidEntry:@"<test>"];
    
    if (!result)XCTFail(@"Entry should be invalid");
}

-(void)testIsValidEntryInvalidDataAtSign
{
    BOOL result = [LKUIStringVerification isInValidEntry:@"te@st"];
    
    if (!result)XCTFail(@"Entry should be invalid");
}

-(void)testIsValidEntryInvalidDataSemicolon
{
    BOOL result = [LKUIStringVerification isInValidEntry:@"tes;t"];
    
    if (!result)XCTFail(@"Entry should be invalid");
}

-(void)testValidDeviceName1
{
    BOOL result = [LKUIStringVerification isDeviceNameValid:DEVICE_VALID1];
    
    if (!result)XCTFail(@"Device name should be valid");
}

-(void)testValidDeviceName2
{
    BOOL result = [LKUIStringVerification isDeviceNameValid:DEVICE_VALID2];
    
    if (!result)XCTFail(@"Device name should be valid");
}

-(void)testValidDeviceName3
{
    BOOL result = [LKUIStringVerification isDeviceNameValid:DEVICE_VALID3];
    
    if (!result)XCTFail(@"Device name should be valid");
}

-(void)testValidDeviceName4
{
    BOOL result = [LKUIStringVerification isDeviceNameValid:DEVICE_VALID4];
    
    if (!result)XCTFail(@"Device name should be valid");
}

-(void)testValidDeviceName5
{
    BOOL result = [LKUIStringVerification isDeviceNameValid:DEVICE_VALID5];
    
    if (!result)XCTFail(@"Device name should be valid");
}

-(void)testValidDeviceName6
{
    BOOL result = [LKUIStringVerification isDeviceNameValid:DEVICE_VALID6];
    
    if (!result)XCTFail(@"Device name should be valid");
}

-(void)testInvalidDeviceName1
{
    BOOL result = [LKUIStringVerification isDeviceNameValid:DEVICE_INVALID_EMOJI];
    
    if (result)XCTFail(@"Device name should be invalid");
}

-(void)testInvalidDeviceName2
{
    BOOL result = [LKUIStringVerification isDeviceNameValid:@""];
    
    if (result)XCTFail(@"Device name should be invalid");
}

-(void)testStringContainsEmoji
{
    BOOL result = [LKUIStringVerification stringContainsEmoji:DEVICE_INVALID_EMOJI];
    if (!result)XCTFail(@"Device name contains emoji");
    
    BOOL cleaned = [LKUIStringVerification stringContainsEmoji:DEVICE_INVALID_EMOJI_CLEANED];
    if (cleaned)XCTFail(@"Device name should be valid");
}

-(void)testPlatformString
{
    if(![[LKUIStringVerification platformString] isEqualToString:@"Simulator"])XCTFail(@"Should return Simulator");
}

-(void)testGetEscapedString
{
    if(![[LKUIStringVerification getEscapedString:@""] isEqualToString:@"dsfnaa92hsfnpaiwh93t4"])XCTFail(@"Returned string is incorrect");
}

@end
