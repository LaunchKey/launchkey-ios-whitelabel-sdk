#import "NSDate+LKTimeAgo.h"

@interface NSDate()
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value;
@end

@implementation NSDate (LKTimeAgo)

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key) \
    NSLocalizedStringFromTable(key, @"NSDateTimeAgo", nil)
#endif


- (NSString *)timeAgo:(NSString*)time
{
    return [self timeAgo:time withAdjustmentFactor:0];
}

- (NSString *)timeAgo:(NSString*)time withAdjustmentFactor:(int)adjust
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSS"];
    NSDate * now;
    if (time == nil)
    {
        now = [NSDate date];
    }
    else
    {
        now = [formatter dateFromString:time];
    }
    
    double deltaSeconds;
    
    if (adjust > 0)
    {
        deltaSeconds = adjust-fabs([self timeIntervalSinceDate:now]);
    }
    else
    {
         deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    }
    
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    NSString *localeFormat;

    if(deltaSeconds < 1)
    {
        return @"Now";
    }
    else if(deltaSeconds < 60)
    {
        localeFormat = [NSString stringWithFormat:@"%%d%@s", [self getLocaleFormatUnderscoresWithValue:(int)deltaSeconds]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), (int)deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"1m");
    }
    else if (deltaMinutes < 60)
    {
        localeFormat = [NSString stringWithFormat:@"%%d%@m", [self getLocaleFormatUnderscoresWithValue:(int)deltaMinutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), (int)deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"1h");
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        localeFormat = [NSString stringWithFormat:@"%%d%@h", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return NSDateTimeAgoLocalizedStrings(@"1d");
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        localeFormat = [NSString stringWithFormat:@"%%d%@d", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return NSDateTimeAgoLocalizedStrings(@"1w");
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
        localeFormat = [NSString stringWithFormat:@"%%d%@w", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return NSDateTimeAgoLocalizedStrings(@"1mon");
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
        localeFormat = [NSString stringWithFormat:@"%%d%@mons", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return NSDateTimeAgoLocalizedStrings(@"1yr");
    }

    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
    localeFormat = [NSString stringWithFormat:@"%%d%@yrs", [self getLocaleFormatUnderscoresWithValue:minutes]];
    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
}

- (NSString *)timeAgoForCache:(NSString*)time withAdjustmentFactor:(int)adjust
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSS"];
    NSDate * now;
    if (time == nil)
    {
        now = [NSDate date];
    }
    else
    {
        now = [formatter dateFromString:time];
    }
    
    double deltaSeconds;
    
    if (adjust > 0)
    {
        deltaSeconds = adjust-fabs([self timeIntervalSinceDate:now]);
    }
    else
    {
        deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    }
    
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    NSString *localeFormat;
    
    if(deltaSeconds <= 1)
    {
        localeFormat = [NSString stringWithFormat:@"%%d%@ second", [self getLocaleFormatUnderscoresWithValue:(int)deltaSeconds]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), (int)deltaSeconds];
    }
    else if(deltaSeconds < 60)
    {
        localeFormat = [NSString stringWithFormat:@"%%d%@ seconds", [self getLocaleFormatUnderscoresWithValue:(int)deltaSeconds]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), (int)deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"1 minute");
    }
    else if (deltaMinutes < 60)
    {
        localeFormat = [NSString stringWithFormat:@"%%d%@ minutes", [self getLocaleFormatUnderscoresWithValue:(int)deltaMinutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), (int)deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"1 hour");
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        localeFormat = [NSString stringWithFormat:@"%%d%@ hours", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return NSDateTimeAgoLocalizedStrings(@"1 days");
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        localeFormat = [NSString stringWithFormat:@"%%d%@ days", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return NSDateTimeAgoLocalizedStrings(@"1 week");
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
        localeFormat = [NSString stringWithFormat:@"%%d%@ weeks", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return NSDateTimeAgoLocalizedStrings(@"1 month");
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
        localeFormat = [NSString stringWithFormat:@"%%d%@ months", [self getLocaleFormatUnderscoresWithValue:minutes]];
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return NSDateTimeAgoLocalizedStrings(@"1 year");
    }
    
    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
    localeFormat = [NSString stringWithFormat:@"%%d%@ years", [self getLocaleFormatUnderscoresWithValue:minutes]];
    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), minutes];
}


- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit
{
    return [self timeAgoWithLimit:limit dateFormat:NSDateFormatterFullStyle andTimeFormat:NSDateFormatterFullStyle];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter
{
    //if (fabs([self timeIntervalSinceDate:[NSDate date]]) <= limit)
    //    return [self timeAgo];
    
    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:dFormatter
                                          timeStyle:tFormatter];
}

// Helper functions

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

/*
 - Author  : Almas Adilbek
 - Method  : getLocaleFormatUnderscoresWithValue
 - Param   : value (Double value of seconds or minutes)
 - Return  : @"" or the set of underscores ("_")
             in order to define exact translation format for specific translation rules.
             (Ex: "%d _seconds ago" for "%d секунды назад", "%d __seconds ago" for "%d секунда назад",
             and default format without underscore %d seconds ago" for "%d секунд назад")
   Updated : 12/12/2012
 
   Note    : This method must be used for all languages that have specific translation rules. 
             Using method argument "value" you must define all possible conditions language have for translation 
             and return set of underscores ("_") as it is an ID for locale format. No underscore ("") means default locale format;
 */
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // Russian (ru)
    if([localeCode isEqual:@"ru"]) {
        NSString *valueStr = [NSString stringWithFormat:@"%.f", value];
        int l = (int)valueStr.length;
        int XY = [[valueStr substringWithRange:NSMakeRange(l - 2, l)] intValue];
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || XY == 11) return @"";
        if(Y != 1 && Y < 5)             return @"_";
        if(Y == 1)                      return @"__";
    }
    
    // Add more languages here, which are have specific translation rules...
    
    return @"";
}

#pragma clang diagnostic pop

@end
