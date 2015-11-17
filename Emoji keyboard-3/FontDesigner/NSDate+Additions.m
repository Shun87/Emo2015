//
//  NSDate+Additions.m
//  iMobileMonitor_Device
//
//  Created by  on 12-5-30.
//  Copyright (c) 2012年 tsinglink. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSString *)formatTime:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)localTime:(time_t)utcTime
{
    NSDate *utcDate = [NSDate dateWithTimeIntervalSince1970:utcTime];
    return [self formatTime:utcDate];
}

- (time_t)utcTime:(NSDate *)localDate
{
    return (time_t)[localDate timeIntervalSince1970];
}

+ (NSDate *)dateFromStr:(NSString *)format time:(NSString *)time
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:time];
}

- (NSString *)stringFromDateFormat:(NSString *)format
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

+ (NSString *)intervalSinceNow:(NSString *)theDate toTime:(NSDate *)date
{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:theDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *adate = date;
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate];
    return [NSString stringWithFormat:@"%.0f", intervalTime];
}
@end
