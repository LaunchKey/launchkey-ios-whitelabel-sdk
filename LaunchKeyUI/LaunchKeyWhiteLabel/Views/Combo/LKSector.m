//
//  LKSector.m
//  CombinationLock
//
//  Created by Kristin Tomasik on 3/4/13.
//  Copyright (c) 2013 LaunchKey, Inc. All rights reserved.
//

#import "LKSector.h"

@implementation LKSector

@synthesize minValue, maxValue, midValue, sector;

- (NSString *) description {
    return [NSString stringWithFormat:@"%i | %f, %f, %f | %i", self.sector, self.minValue, self.midValue, self.maxValue, self.angle];
}


@end
