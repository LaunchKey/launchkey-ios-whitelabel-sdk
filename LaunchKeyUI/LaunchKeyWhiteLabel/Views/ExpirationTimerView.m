//
//  ExpirationTimerView.m
//  Authenticator
//
//  Created by ani on 11/13/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import "ExpirationTimerView.h"
#import "LKUIConstants.h"
#import "AuthResponseExpirationTimerView.h"
#import "LaunchKeyUIBundle.h"

@interface ExpirationWeakTimerTarget : NSObject

@property (weak) id target;
@property (assign) SEL selector;
@property (weak) NSTimer* timer;

@end

@implementation ExpirationWeakTimerTarget

- (void)fire
{
    if(self.target)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.timer];
#pragma clang diagnostic pop
    }
    else
    {
        [self.timer invalidate];
    }
}

@end

@interface ExpirationTimerView ()
{
    CAShapeLayer *timeLeftShapeLayer;
    CAShapeLayer *backgroundShapeLayer;
    UILabel *timeLabel;
    NSTimer *timer;
    NSTimeInterval timeLeft;
    CABasicAnimation *strokeIt;
    CGFloat timerWidth, timerLineWidth, timerRadius;
}

@end

@implementation ExpirationTimerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Remove any subviews
    // Added the following due to a weird bug on iOS 12 where subview of
    // time label would remain when app would return to foreground
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    // Calculate Radius
    if(_isBigTimer)
        timerRadius = (self.frame.size.width / 2);
    else
        timerRadius = (self.frame.size.width / 3);
    
    // Calculated Line Width
    if(_isBigTimer)
        timerLineWidth = timerRadius / 2;
    else
        timerLineWidth = timerRadius * 2;
    
    timeLeft = _expirationDuration;
    
    // Draw Circles + Label
    [self drawBackgroundCircle:rect];
    [self drawTimeLeft:rect];
    [self addTimeLabel:rect];
    
    // Calculate start position of timer
    CGFloat durationLeft = [_expiresAt intValue] - [[self timeStamp]intValue];
    
    // Add Progress Stroke
    strokeIt = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeIt.fromValue = @((float)((_expirationDuration - durationLeft)/_expirationDuration));
    strokeIt.toValue = @(1);
    strokeIt.duration = durationLeft;
    strokeIt.removedOnCompletion = NO;
    [timeLeftShapeLayer addAnimation:strokeIt forKey:nil];
    
    // Schedule Timer
    timer = [self scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

-(NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    ExpirationWeakTimerTarget* timerTarget = [[ExpirationWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:timerTarget selector:@selector(fire) userInfo:userInfo repeats:yesOrNo];
    return timerTarget.timer;
}

#pragma mark - Draw Methods
-(void)drawBackgroundCircle:(CGRect)rect
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
                          radius:timerRadius
                      startAngle:ToRad(-90)
                        endAngle:ToRad(270)
                       clockwise:YES];
    
    backgroundShapeLayer = [CAShapeLayer layer];
    backgroundShapeLayer.path = bezierPath.CGPath;
    backgroundShapeLayer.strokeColor = ([AuthResponseExpirationTimerView appearance].backgroundColor.CGColor != nil) ? [AuthResponseExpirationTimerView appearance].backgroundColor.CGColor : defaultExpirationTimerBackgroundColor.CGColor;
    backgroundShapeLayer.fillColor = [UIColor clearColor].CGColor;
    backgroundShapeLayer.lineWidth = timerLineWidth;
    
    [[self layer] addSublayer:backgroundShapeLayer];
}

-(void)drawTimeLeft:(CGRect)rect
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
                          radius:timerRadius
                      startAngle:ToRad(-90)
                        endAngle:ToRad(270)
                       clockwise:YES];
    
    timeLeftShapeLayer = [CAShapeLayer layer];
    timeLeftShapeLayer.path = bezierPath.CGPath;
    timeLeftShapeLayer.strokeColor = ([AuthResponseExpirationTimerView appearance].fillColor.CGColor != nil) ? [AuthResponseExpirationTimerView appearance].fillColor.CGColor : defaultExpirationTimerFillColor.CGColor;
    timeLeftShapeLayer.fillColor = [UIColor clearColor].CGColor;
    timeLeftShapeLayer.lineWidth = timerLineWidth;
    
    [[self layer] addSublayer:timeLeftShapeLayer];
}

-(void)addTimeLabel:(CGRect)rect
{    
    if(_isBigTimer)
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(rect) - 50, CGRectGetMidY(rect) - 25, 100, 50)];
    else
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(rect) - self.frame.size.width - 50, CGRectGetMidY(rect) - 12, 50, 25)];
    
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = [self time:timeLeft];
    timeLabel.textColor = ([AuthResponseExpirationTimerView appearance].fillColor != nil) ? [AuthResponseExpirationTimerView appearance].fillColor : defaultExpirationTimerFillColor;
    if(_isBigTimer)
        [timeLabel setFont:[UIFont fontWithName:@"Arial" size:27]];
    else
        [timeLabel setFont:[UIFont fontWithName:@"Arial" size:20]];
    timeLabel.numberOfLines = 1;
    timeLabel.minimumScaleFactor = 8./timeLabel.font.pointSize;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:timeLabel];
}

#pragma mark - Update Time
-(void)updateTime
{
    // If time left is <= 10 seconds, change color of
    // circle and time label to warning color
    if(lroundf(timeLeft)<= 10.00)
    {
        // Turn stroke color red
        timeLeftShapeLayer.strokeColor = ([AuthResponseExpirationTimerView appearance].warningColor.CGColor != nil) ? [AuthResponseExpirationTimerView appearance].warningColor.CGColor : defaultExpirationTimerWarningColor.CGColor;
        timeLabel.textColor = ([AuthResponseExpirationTimerView appearance].warningColor != nil) ? [AuthResponseExpirationTimerView appearance].warningColor : defaultExpirationTimerWarningColor;
    }
    
    if(timeLeft > 0)
    {
        timeLeft = [NSDate dateWithTimeIntervalSince1970:_expiresAt.doubleValue].timeIntervalSinceNow;
        timeLabel.text = [self time:timeLeft];
        [timeLabel setAccessibilityLabel:[self setAccessibilityForTimerWithMinutes:(int)(timeLeft/60) withSeconds:(int)timeLeft % 60]];
    }
    else
    {
        timeLabel.text = @"00:00";
        [timer invalidate];
        
        // Post notification that timer expired
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerExpired" object:self];
    }
}

#pragma mark - Time Left Helper Methods
-(NSString*)time:(NSTimeInterval)timeLeft
{
    NSString *timeToReturn = [NSString stringWithFormat:@"%02d:%02d", (int)(timeLeft/60), (int)timeLeft % 60];
    return timeToReturn;
}

- (NSString*)timeStamp
{
    return [NSString stringWithFormat:@"%lu", (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970])];
}

#pragma mark - Accessibility For Timer
-(NSString*)setAccessibilityForTimerWithMinutes:(int)minutes withSeconds:(int)seconds
{
    NSString *timerMinutes = @"";
    NSString *timerSeconds = @"";
    NSString *timerAnd = NSLocalizedStringFromTableInBundle(@"Expires_In_Timer_And", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(minutes == 0 && seconds == 0)
    {
        return NSLocalizedStringFromTableInBundle(@"Expires_In_Timer_Expired", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    
    if (minutes == 1)
    {
        timerMinutes = NSLocalizedStringFromTableInBundle(@"Expires_In_Timer_Minute", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    else if(minutes == 0)
    {
        timerAnd = @"";
    }
    else
    {
        timerMinutes = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Expires_In_Timer_Minutes", @"Localizable", [NSBundle LaunchKeyUIBundle],nil), minutes];
    }
    
    if(seconds == 1)
    {
        timerSeconds = NSLocalizedStringFromTableInBundle(@"Expires_In_Timer_Second", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    else if(seconds == 0)
    {
        timerAnd = @"";
    }
    else
    {
        timerSeconds = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Expires_In_Timer_Seconds", @"Localizable", [NSBundle LaunchKeyUIBundle],nil), seconds];
    }
    
    return [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Expires_In_Timer_Accessibility_Label", @"Localizable", [NSBundle LaunchKeyUIBundle],nil), timerMinutes, timerAnd, timerSeconds];
}

#pragma mark - Invalidate Timer
-(void)invalidateTimer
{
    [timer invalidate];
}
@end
