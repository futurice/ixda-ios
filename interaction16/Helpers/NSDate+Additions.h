//
//  NSDate+Additions.h
//  FestApp
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_Additions)

#define kAlertIntervalInMinutes    15

#define kOneMinute                (60)
#define kOneHour                  (60*60)
#define kDayDelimiterHour          6

- (BOOL)before:(NSDate *)other;
- (BOOL)after:(NSDate *)other;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSDate *)sameDateWithMidnightTimestamp;
- (float)hourValueWithDayDelimiterHour:(NSInteger)dayDelimiterHour;
- (NSString *)hourAndMinuteString;
- (NSString *)weekdayName;
- (NSString *)posixWeekdayName;

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;

@end
