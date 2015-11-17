//
//  UserParameter.m
//  Smart Merge
//
//  Created by tsinglink on 15/11/2.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import "UserParameter.h"

#define kAppFirtLuanchTime     @"kAppFirtLuanchTime"
#define kNumOfSwitchPage        @"kNumOfSwitchPage"

#define kHasRateApp             @"kHasRateApp"
#define kLastRejectRateDate     @"kLastRejectRateDate"

@interface UserParameter()
{
    NSMutableDictionary *localDic;
}
@end

@implementation UserParameter

+(UserParameter *)sharedInstance
{
    static dispatch_once_t once;
    static UserParameter *s_userParameter = nil;
    dispatch_once(&once, ^{
        
        if (s_userParameter == nil)
        {
            s_userParameter = [[UserParameter alloc] init];
        }
    });
    
    return s_userParameter;
}

+ (NSString *)dateString:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromStr:(NSString *)dateStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    return [dateFormatter dateFromString:dateStr];
}

- (id)init
{
    if (self = [super init])
    {
        localDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self usrParamerter]];
        if (localDic == nil)
        {
            localDic = [[NSMutableDictionary alloc] init];
        }
        
        NSString *dateStr = [localDic objectForKey:kAppFirtLuanchTime];
        if ([dateStr length] == 0)
        {
            NSString *dateStr = [UserParameter dateString:[NSDate date]];
            [localDic setObject:dateStr forKey:kAppFirtLuanchTime];
            [self save];
        }
    }
    
    return self;
}

- (BOOL)needShowRateView
{
    int maxActionCnt = 25;
    uint secs = 60 * 20;
    
    BOOL readyToShow = NO;
    int switchCnt = [[localDic objectForKey:kNumOfSwitchPage] intValue]; 
    NSString *dateStr = [localDic objectForKey:kAppFirtLuanchTime];
    if (dateStr != nil)
    {
        uint luanchUtc = [[UserParameter dateFromStr:dateStr] timeIntervalSince1970];
        uint currentUtc = [[NSDate date] timeIntervalSince1970];
        if (currentUtc - luanchUtc > secs && switchCnt >= maxActionCnt)
        {
            // 已经使用超过20分钟了
            readyToShow = YES;
        }
    }

    if (readyToShow)
    {
        BOOL hasRated = [[localDic objectForKey:kHasRateApp] boolValue];
        if (!hasRated)
        {
            NSString *rejectDateStr = [localDic objectForKey:kLastRejectRateDate];
            if ([rejectDateStr length] == 0)
            {
                // 还没显示过
                readyToShow = YES;
            }
            else
            {
                uint rejectUtc = [[UserParameter dateFromStr:rejectDateStr] timeIntervalSince1970];
                uint currentUtc = [[NSDate date] timeIntervalSince1970];
                if (currentUtc - rejectUtc > secs / 2 || switchCnt >= maxActionCnt)
                {
                    readyToShow = YES;
                }
                else
                {
                    readyToShow = NO;
                }
            }
        }
        else
        {
            readyToShow = NO;
        }
    }
    
    return readyToShow;
}

- (void)rateUs
{
    [localDic setObject:[NSNumber numberWithBool:YES] forKey:kHasRateApp];
    [localDic setObject:@"" forKey:kLastRejectRateDate];
    [localDic setObject:[NSNumber numberWithInt:0] forKey:kNumOfSwitchPage];
    [self save];
}

- (void)rejectRate
{
    NSString *dateStr = [UserParameter dateString:[NSDate date]];
    [localDic setObject:dateStr forKey:kLastRejectRateDate];
    [localDic setObject:[NSNumber numberWithInt:0] forKey:kNumOfSwitchPage];
    [self save];
}

- (void)doSwitchAction
{
    int count = [[localDic objectForKey:kNumOfSwitchPage] intValue];
    count++;
    [localDic setObject:[NSNumber numberWithInt:count] forKey:kNumOfSwitchPage];
    [localDic writeToFile:[self usrParamerter] atomically:YES];
}

- (void)save
{
    [localDic writeToFile:[self usrParamerter] atomically:YES];
}

- (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)usrParamerter
{
    NSString *docPath = [self documentPath];
    NSString *path = [docPath stringByAppendingPathComponent:@"usrParamerter.plist"];
    return path;
}

@end
