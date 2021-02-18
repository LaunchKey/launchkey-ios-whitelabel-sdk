//
//  LKSector_Test.m
//  Authenticator
//
//  Created by ani on 3/30/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LKSector.h"

@interface LKSector_Test : XCTestCase

@end

@implementation LKSector_Test

- (void)setUp
{
    [super setUp];
    
    LKSector *sector = [[LKSector alloc] init];
    sector.minValue = 6.0;
    sector.midValue = 12.0;
    sector.maxValue = 24.0;
    sector.angle = 45;
}

-(void)testDescription
{
    NSString *description = [LKSector description];
    
    if(description.length == 0)XCTFail(@"Description should not be of length 0");
}

@end
