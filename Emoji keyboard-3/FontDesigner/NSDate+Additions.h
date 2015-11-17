//
//  NSDate+Additions.h
//  iMobileMonitor_Device
//
//  Created by  on 12-5-30.
//  Copyright (c) 2012年 tsinglink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

- (NSString *)localTime:(time_t)utcTime;
- (time_t)utcTime:(NSDate *)localDate;

+ (NSDate *)dateFromStr:(NSString *)format time:(NSString *)time;
- (NSString *)stringFromDateFormat:(NSString *)format;
+ (NSString *)intervalSinceNow:(NSString *)theDate toTime:(NSDate *)date;
@end
