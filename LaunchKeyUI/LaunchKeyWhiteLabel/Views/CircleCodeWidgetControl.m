//
//  CircleCodeWidgetControl.m
//  LaunchKey
//
//  Created by ani on 1/3/16.
//  Copyright © 2016 LaunchKey, Inc. All rights reserved.
//

#import "CircleCodeWidgetControl.h"
#import "LKSector.h"
#import "SecurityCircleCodeViewController.h"
#import "LKUIConstants.h"
#import "CircleCodeImageView.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import <LKCAuthenticator/LKCCircleCodeManager.h>

@implementation CircleCodeWidgetControl
{
    UIButton *topHash, *bottomHash, *leftHash, *rightHash, *topFortyFiveHash, *bottomFortyFiveHash, *topMinusFortyFiveHash, *bottomMinusFortyFiveHash;
    int radius;
    CAShapeLayer *currentLayer;
}

@synthesize container, numberOfSections, sectors, hash, createCombo, delegate;

int previousSector;
NSString *combo, *oldCombo;
UIImageView *lkCenterLogo;
NSArray *angleArray;
NSMutableArray *patternArray, *oldPatternArray;
CGPoint centerPoint;
API_AVAILABLE(ios(10.0))
UIImpactFeedbackGenerator *feedbackGenerator;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)del
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.numberOfSections = 8;
        self.delegate = del;
        [self drawCombo];
        self.angle = 360;
        oldCombo = @"";
        oldPatternArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawCombo
{
    [self drawHashes];
    
    angleArray = @[@270, @315, @0, @45, @90, @135, @180, @225];
    patternArray = [[NSMutableArray alloc] init];
    
    container = [[UIView alloc] initWithFrame:self.frame];
    
    [self centerInactive:YES];
    
    CGFloat angleSize = 2 * M_PI/numberOfSections;
    
    for (int i = 0; i < numberOfSections; i++)
    {
        if (i == 2)
        {
            hash = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            hash.clipsToBounds = NO;
            hash.isAccessibilityElement = YES;
            hash.accessibilityLabel = @"Hash";
            hash.layer.cornerRadius = hash.frame.size.height / 2;
            hash.layer.masksToBounds = YES;
            hash.backgroundColor = [UIColor blueColor];
            
            hash.layer.position = CGPointMake(container.bounds.size.width/2.0, 40);
            hash.transform = CGAffineTransformMakeRotation(angleSize * i);
            
            [hash setAlpha:0.7f];
            
            [container addSubview:hash];
            
            hash.hidden = YES;
        }
    }
    
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    
    sectors = [NSMutableArray arrayWithCapacity:numberOfSections];
    [self buildSectorsEven];
    
    float halfW = hash.frame.size.width / 2;
    radius = (self.frame.size.width/2) - 27.5 - halfW;
    
    lkCenterLogo = [[CircleCodeImageView alloc] initWithFrame:CGRectMake(self.center.x - (0.50 * radius / 2), self.center.y - (0.50 * radius / 2), 0.50 * radius, 0.50 * radius)];
    if([CircleCodeImageView appearance].defaultColor != nil)
        lkCenterLogo.backgroundColor = [CircleCodeImageView appearance].defaultColor;
    else
        lkCenterLogo.backgroundColor = [UIColor darkGrayColor];
    
    lkCenterLogo.layer.cornerRadius = lkCenterLogo.frame.size.height/2;
    lkCenterLogo.layer.masksToBounds = YES;
    [self addSubview:lkCenterLogo];
    
    centerPoint = CGPointMake(lkCenterLogo.center.x, lkCenterLogo.center.y);
    
    [self bringSubviewToFront:hash];
}

#pragma mark - Draw Hashes
-(void)drawHashes
{
    UIColor *defaultColor;
    if([CircleCodeImageView appearance].defaultColor != nil)
        defaultColor = [CircleCodeImageView appearance].defaultColor;
    else
        defaultColor = [UIColor darkGrayColor];
    
    UIFont *font = [UIFont boldSystemFontOfSize:30];
    UIColor *color = defaultColor;
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"|" attributes:attributes]];
    
    // Draw Hashes
    topHash = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x - 20, 36, 40, 40)];
    [topHash setAttributedTitle:attString forState:UIControlStateNormal];
    topHash.backgroundColor = [UIColor clearColor];
    topHash.accessibilityIdentifier = @"circleCodeHash_up";
    [self addSubview:topHash];
    
    bottomHash = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x - 20, 295, 40, 40)];
    [bottomHash setAttributedTitle:attString forState:UIControlStateNormal];
    bottomHash.backgroundColor = [UIColor clearColor];
    bottomHash.accessibilityIdentifier = @"circleCodeHash_down";
    [self addSubview:bottomHash];
    
    leftHash = [[UIButton alloc] initWithFrame:CGRectMake(40, self.center.y - 20, 40, 40)];
    [leftHash setAttributedTitle:attString forState:UIControlStateNormal];
    leftHash.backgroundColor = [UIColor clearColor];
    leftHash.accessibilityIdentifier = @"circleCodeHash_left";
    [self addSubview:leftHash];
    
    rightHash = [[UIButton alloc] initWithFrame:CGRectMake(300, self.center.y - 20, 40, 40)];
    [rightHash setAttributedTitle:attString forState:UIControlStateNormal];
    rightHash.backgroundColor  = [UIColor clearColor];
    rightHash.accessibilityIdentifier = @"circleCodeHash_right";
    [self addSubview:rightHash];
    
    topFortyFiveHash = [[UIButton alloc] initWithFrame:CGRectMake(262, 75, 40, 40)];
    [topFortyFiveHash setAttributedTitle:attString forState:UIControlStateNormal];
    topFortyFiveHash.backgroundColor = [UIColor clearColor];
    topFortyFiveHash.accessibilityIdentifier = @"circleCodeHash_upRight";
    [self addSubview:topFortyFiveHash];
    
    bottomFortyFiveHash = [[UIButton alloc] initWithFrame:CGRectMake(262, 260, 40, 40)];
    [bottomFortyFiveHash setAttributedTitle:attString forState:UIControlStateNormal];
    bottomFortyFiveHash.backgroundColor = [UIColor clearColor];
    bottomFortyFiveHash.accessibilityIdentifier = @"circleCodeHash_downRight";
    [self addSubview:bottomFortyFiveHash];
    
    topMinusFortyFiveHash = [[UIButton alloc] initWithFrame:CGRectMake(71, 76, 40, 40)];
    [topMinusFortyFiveHash setAttributedTitle:attString forState:UIControlStateNormal];
    topMinusFortyFiveHash.backgroundColor = [UIColor clearColor];
    topMinusFortyFiveHash.accessibilityIdentifier = @"circleCodeHash_upLeft";
    [self addSubview:topMinusFortyFiveHash];
    
    bottomMinusFortyFiveHash = [[UIButton alloc] initWithFrame:CGRectMake(71, 258, 40, 40)];
    [bottomMinusFortyFiveHash setAttributedTitle:attString forState:UIControlStateNormal];
    bottomMinusFortyFiveHash.backgroundColor = [UIColor clearColor];
    bottomMinusFortyFiveHash.accessibilityIdentifier = @"circleCodeHash_downLeft";
    [self addSubview:bottomMinusFortyFiveHash];
    
    leftHash.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
    rightHash.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
    topFortyFiveHash.transform = CGAffineTransformMakeRotation( ( 45 * M_PI ) / 180 );
    bottomMinusFortyFiveHash.transform = CGAffineTransformMakeRotation( ( 225 * M_PI ) / 180 );
    topMinusFortyFiveHash.transform = CGAffineTransformMakeRotation( ( 315 * M_PI ) / 180 );
    bottomFortyFiveHash.transform = CGAffineTransformMakeRotation( ( 135 * M_PI ) / 180 );
    
    topHash.enabled = NO;
    bottomHash.enabled = NO;
    leftHash.enabled = NO;
    rightHash.enabled = NO;
    topFortyFiveHash.enabled = NO;
    bottomFortyFiveHash.enabled = NO;
    topMinusFortyFiveHash.enabled = NO;
    bottomMinusFortyFiveHash.enabled = NO;
}

#pragma mark - Build Sectors
- (void)buildSectorsEven
{
    const float increment = 45.0;
    const float incrementHalf = increment / 2.0;
    float angleMark;
    
    for (int i = 0; i < numberOfSections; i++)
    {
        LKSector *sector = [[LKSector alloc] init];
        angleMark = i * increment;
        if(i == 0)
            sector.minValue = ToRad(angleMark - incrementHalf + 360);
        else
            sector.minValue = ToRad(angleMark - incrementHalf);
        
        sector.maxValue = ToRad(angleMark + incrementHalf);
        sector.midValue = ToRad(angleMark);
        
        sector.sector = i;
        sector.angle = [(NSNumber *)[angleArray objectAtIndex:i] intValue];
        [sectors addObject:sector];
    }
}

-(void)centerInactive:(BOOL)hidden
{
    if(hidden)
    {
        if([CircleCodeImageView appearance].defaultColor != nil)
            lkCenterLogo.backgroundColor = [CircleCodeImageView appearance].defaultColor;
        else
            lkCenterLogo.backgroundColor = [UIColor darkGrayColor];
    }
    else
    {
        if([CircleCodeImageView appearance].highlightColor != nil)
            lkCenterLogo.backgroundColor = [CircleCodeImageView appearance].highlightColor;
        else
            lkCenterLogo.backgroundColor = [UIColor blueColor];
    }
}

#pragma mark - Reset Methods
- (void)resetCombo
{
    combo = @"";
    [patternArray removeAllObjects];
    hash.hidden = YES;
    [currentLayer removeFromSuperlayer];
    [self moveToCenter];
}

- (void)moveToCenter
{
    container.transform = CGAffineTransformIdentity;
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    [self getClosestSector:radians];
}

#pragma mark - Touch Events
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Haptic Feedback for iOS10+
    if (@available(iOS 10.0, *)) {
        feedbackGenerator = [[UIImpactFeedbackGenerator alloc] init];
        [feedbackGenerator prepare];
        [feedbackGenerator impactOccurred];
        [feedbackGenerator prepare];
    }
    
    [self centerInactive:NO];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, touchPoint, NO);
    int angleInt = floor(currentAngle);
    
    //Store the new angle
    self.angle = 360 - angleInt;
    
    // Calculate Radians
    if(angleInt >= 0 && angleInt < 270)
        angleInt = angleInt + 90;
    else if(angleInt >= 270 && angleInt <= 360)
        angleInt = angleInt - 270;
    
    CGFloat radians = ToRad(angleInt);
    int sectorSelected = [self getClosestSector:radians];
    
    // Set first sector
    NSNumber* sectorSelectedNum = [NSNumber numberWithInt:sectorSelected];
    [patternArray addObject:sectorSelectedNum];
    combo = [NSString stringWithFormat:@"%d", sectorSelected];
    
    // highlight sector
    LKSector *sector = [sectors objectAtIndex:sectorSelected];
    currentLayer = [self createPieSlice:sector.angle];
    [self.container.layer addSublayer:currentLayer];
    
    previousSector = sectorSelected;
    
    if([self calculateDistanceFromCenter:touchPoint] <= 0.25 * radius)
    {
        [self endTrackingWithTouch:touch withEvent:event];
        return NO;
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    CGPoint pt = [touch locationInView:self];
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, pt, NO);
    int angleInt = floor(currentAngle);
    
    //Store the new angle
    self.angle = 360 - angleInt;
    
    // Calculate Radians
    if(angleInt >= 0 && angleInt < 270)
        angleInt = angleInt + 90;
    else if(angleInt >= 270 && angleInt <= 360)
        angleInt = angleInt - 270;
    CGFloat radians = ToRad(angleInt);
    int sectorSelected = [self getClosestSector:radians];
    
    // highlight sector upon change
    if(sectorSelected != previousSector)
    {
        [currentLayer removeFromSuperlayer];
        LKSector *newSector = [sectors objectAtIndex:sectorSelected];
        currentLayer = [self createPieSlice:newSector.angle];
        [self.container.layer addSublayer:currentLayer];
        previousSector = sectorSelected;
        
        // Haptic Feedback for iOS10+
        if (@available(iOS 10.0, *)) {
            [feedbackGenerator impactOccurred];
            [feedbackGenerator prepare];
        }
        
        //Save sector
        NSNumber* sectorSelectedNum = [NSNumber numberWithInt:sectorSelected];
        [patternArray addObject:sectorSelectedNum];
        combo = [NSString stringWithFormat:@"%@,%d", combo, sectorSelected];
    }
    
    if([self calculateDistanceFromCenter:pt] <= 0.25 * radius)
    {
        [self endTrackingWithTouch:touch withEvent:event];
        return NO;
    }
    
    // Count hashes, force stop if too high
    if([patternArray count] > 120)
    {
        [self endTrackingWithTouch:touch withEvent:event];
        return NO;
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    [self centerInactive:YES];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, touchPoint, NO);
    int angleInt = floor(currentAngle);
    
    if(angleInt >= 0 && angleInt < 270)
        angleInt = angleInt + 90;
    else if(angleInt >= 270 && angleInt <= 360)
        angleInt = angleInt - 270;
    CGFloat radians = ToRad(angleInt);
    int lastSector = [self getClosestSector:radians];
    
    if(lastSector != previousSector)
    {
        NSNumber* sectorSelectedNum = [NSNumber numberWithInt:lastSector];
        [patternArray addObject:sectorSelectedNum];
        combo = [NSString stringWithFormat:@"%@,%d", combo, lastSector];
    }
    
    [self processPattern:patternArray];
    [self resetCombo];
}

- (int)getClosestSector:(CGFloat)radians
{
    int thisSector = 0;
    
    for (LKSector *s in sectors)
    {
        if (s.minValue > 0 && s.maxValue < 0)
        {
            if (s.maxValue > radians || s.minValue < radians)
                thisSector = s.sector;
        }
        else if (radians > s.minValue && radians < s.maxValue)
            thisSector = s.sector;
    }
    
    return thisSector;
}

#pragma mark - Create Pie Slice
- (UIColor*)fillForColor:(UIColor *)color
{
    return [color colorWithAlphaComponent:0.3f];
}

-(CAShapeLayer *)createPieSlice:(int)angle
{
    float incrementHalf = 22.5;
    CAShapeLayer *slice = [CAShapeLayer layer];
    
    if([CircleCodeImageView appearance].highlightColor != nil)
        slice.fillColor = [self fillForColor:[CircleCodeImageView appearance].highlightColor].CGColor;
    else
        slice.fillColor = [self fillForColor:[UIColor blueColor]].CGColor;
    slice.strokeColor = [UIColor clearColor].CGColor;
    slice.lineWidth = 0;
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:centerPoint];
    [piePath addArcWithCenter:centerPoint radius:(radius + 8) startAngle:ToRad(angle - incrementHalf) endAngle:ToRad(angle + incrementHalf)  clockwise:YES];
    [piePath closePath];
    slice.path = piePath.CGPath;
    
    return slice;
}

#pragma mark - Helper Methods
/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Circle center
    
    //The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt)));
    
    return result;
}

//Sourcecode from Apple example clockControl
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped)
{
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

- (float)calculateDistanceFromCenter:(CGPoint)point
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    return distanceBetweenTwoPoints(point, center);
}

static inline float distanceBetweenTwoPoints(CGPoint p1, CGPoint p2)
{
    float dx = p1.x - p2.x;
    float dy = p1.y - p2.y;
    return sqrt(dx*dx + dy*dy);
}

#pragma mark - Process Pattern
-(void)processPattern:(NSMutableArray*)pattern
{
    //build direction sequence based on index sequence
    int index,prevIndex;
    NSMutableArray *directions = [[NSMutableArray alloc] init];
    
    //starting with second index to compare with previous
    for (int i = 1; i < [pattern count]; i++)
    {
        index = [[pattern objectAtIndex:i] intValue];
        prevIndex = [[pattern objectAtIndex:i -1 ] intValue];
        BOOL isClockwise = (index == 0 && prevIndex == 7) || (index == prevIndex + 1);
        [directions insertObject:[NSNumber numberWithBool:isClockwise] atIndex:(i -1)];
    }
    
    //build a string representation of the resulting pattern
    NSString *patternString = @"";
    patternString = [[patternString stringByAppendingString:@"["] stringByAppendingString:[[pattern objectAtIndex:0] stringValue]];
    
    for (int di = 1; di < [directions count]; di++)
    {
        //farthest point before change
        if (directions[di] != directions[di - 1])
        {
            if([[directions objectAtIndex:di - 1]intValue] == 1)
                patternString = [[patternString stringByAppendingString:@" > "] stringByAppendingString:[[pattern objectAtIndex:di] stringValue]];
            else
                patternString = [[patternString stringByAppendingString:@" < "] stringByAppendingString:[[pattern objectAtIndex:di] stringValue]];
        }
    }
    
    //only if there has been movement, attach the last hit
    if ([directions count] > 0)
    {
        //last index--change in direction is not registered for very last point
        if([[directions objectAtIndex:[directions count] - 1]intValue] == 1)
            patternString = [[patternString stringByAppendingString:@" > "] stringByAppendingString:[[pattern objectAtIndex:([pattern count] - 1)] stringValue]];
        else
            patternString = [[patternString stringByAppendingString:@" < "] stringByAppendingString:[[pattern objectAtIndex:([pattern count] - 1)] stringValue]];
    }
    
    patternString = [patternString stringByAppendingString:@"]"];
    
    combo = patternString;
    
    [self verifyCombo];
}

- (void)verifyCombo
{
    if(createCombo)
    {
        NSString *numberString = [combo stringByReplacingOccurrencesOfString:@"," withString:@""];
        numberString = [numberString stringByReplacingOccurrencesOfString:@"[" withString:@""];
        numberString = [numberString stringByReplacingOccurrencesOfString:@"]" withString:@""];

        int number = (int)[numberString length];
        int patternArrayCount = (int)[patternArray count];
        
        if ([oldCombo isEqualToString:@""] && (number < 2 || patternArrayCount > 120))
        {
            //invalid string
            createCombo = YES;
            oldCombo = @"";
            [oldPatternArray removeAllObjects];
            [self resetCombo];
            
            if(number < circleCodeMinimum)
            {
                [self.delegate invalidShortComboSet];
            }
            else if(patternArrayCount > circleCodeMaximum)
            {
                [self.delegate invalidLongComboSet];
            }
        }
        else if (![oldCombo isEqualToString:@""] && [combo isEqualToString:oldCombo])
        {
            createCombo = NO;
            [self resetCombo];
            [self.delegate comboSetAndDismissedWithCircleCode:oldPatternArray];
        }
        else if (![oldCombo isEqualToString:@""])
        {
            //combos do not match. try again
            createCombo = YES;
            oldCombo = @"";
            [oldPatternArray removeAllObjects];
            [self resetCombo];
            [self.delegate combosDoNotMatch];
        }
        else
        {
            //first combo is valid
            createCombo = YES;
            oldCombo = combo;
            oldPatternArray = [patternArray mutableCopy];
            [self resetCombo];
            [self.delegate firstComboSet];
        }
    }
    else
    {
        [self.delegate comboUnlockedWithCircleCode:patternArray];
    }
}

@end
