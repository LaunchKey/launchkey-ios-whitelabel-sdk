//
//  ExpirationTimer_Test.m
//  AuthenticatorTests
//
//  Created by ani on 10/11/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExpirationTimerView.h"

@interface ExpirationTimer_Test : XCTestCase

@end

@interface ExpirationTimerView (Tests)
-(NSString*)setAccessibilityForTimerWithMinutes:(int)minutes withSeconds:(int)seconds;
@end

@implementation ExpirationTimer_Test

ExpirationTimerView *timerView;

- (void)setUp
{
    timerView = [[ExpirationTimerView alloc] init];
}

//-(void)testSecond
//{
//    if(![[timerView setAccessibilityForTimerWithMinutes:0 withSeconds:1] isEqualToString:@"Expires in 1 second"])XCTFail(@"Returned accessibility label is incorrect");
//}
//
//-(void)testSeconds
//{
//    if(![[timerView setAccessibilityForTimerWithMinutes:0 withSeconds:5] isEqualToString:@"Expires in 5 seconds"])XCTFail(@"Returned accessibility label is incorrect");
//}
//
//-(void)testOneMinute
//{
//    if(![[timerView setAccessibilityForTimerWithMinutes:1 withSeconds:0] isEqualToString:@"Expires in 1 minute"])XCTFail(@"Returned accessibility label is incorrect");
//}

-(void)testOneMinuteAndSecond
{
    if(![[timerView setAccessibilityForTimerWithMinutes:1 withSeconds:1] isEqualToString:@"Expires in 1 minute and 1 second"])XCTFail(@"Returned accessibility label is incorrect");
}

-(void)testOneMinuteAndSeconds
{
    if(![[timerView setAccessibilityForTimerWithMinutes:1 withSeconds:40] isEqualToString:@"Expires in 1 minute and 40 seconds"])XCTFail(@"Returned accessibility label is incorrect");
}

//-(void)testMinutes
//{
//    if(![[timerView setAccessibilityForTimerWithMinutes:2 withSeconds:0] isEqualToString:@"Expires in 2 minutes"])XCTFail(@"Returned accessibility label is incorrect");
//}
//
//-(void)testMinutesAndSecond
//{
//    if(![[timerView setAccessibilityForTimerWithMinutes:4 withSeconds:1] isEqualToString:@"Expires in 3 minutes and 1 second"])XCTFail(@"Returned accessibility label is incorrect");
//}
//
//-(void)testMinutesAndSeconds
//{
//    if(![[timerView setAccessibilityForTimerWithMinutes:6 withSeconds:59] isEqualToString:@"Expires in 6 minutes and 59 seconds"])XCTFail(@"Returned accessibility label is incorrect");
//}

-(void)testExpired
{
    if(![[timerView setAccessibilityForTimerWithMinutes:0 withSeconds:0] isEqualToString:@"Expired"])XCTFail(@"Returned accessibility label is incorrect");
}

@end
