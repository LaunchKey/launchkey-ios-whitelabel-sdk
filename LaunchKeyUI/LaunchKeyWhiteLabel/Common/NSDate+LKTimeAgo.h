#import <Foundation/Foundation.h>

@interface NSDate (LKTimeAgo)
- (NSString *)timeAgo:(NSString*)time;
- (NSString *)timeAgo:(NSString*)time withAdjustmentFactor:(int)adjust;
- (NSString *)timeAgoForCache:(NSString*)time withAdjustmentFactor:(int)adjust;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;
@end

