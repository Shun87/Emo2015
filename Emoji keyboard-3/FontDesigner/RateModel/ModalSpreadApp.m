//
//  ModalSpreadApp.m
//  Emoji keyboard
//
//  Created by tsinglink on 15/11/17.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import "ModalSpreadApp.h"
#import "NSDate+Additions.h"

@interface ModalSpreadApp()
{
    NSMutableDictionary *localDic;
}
@end

@implementation ModalSpreadApp

+(ModalSpreadApp *)sharedInstance
{
    static dispatch_once_t once;
    static ModalSpreadApp *s_userParameter = nil;
    dispatch_once(&once, ^{
        
        if (s_userParameter == nil)
        {
            s_userParameter = [[ModalSpreadApp alloc] init];
        }
    });
    
    return s_userParameter;
}


- (id)init
{
    if (self = [super init])
    {
        localDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self spreadParamerter]];
        if (localDic == nil)
        {
            localDic = [[NSMutableDictionary alloc] init];
        }
    }
    
    return self;
}

- (void)showOtherApp
{
    BOOL show3D = [[localDic valueForKey:@"Show3DEmojis"] boolValue];
    if (!show3D)
    {
        [self showMore3D];
        [localDic setValue:[NSNumber numberWithBool:YES] forKey:@"Show3DEmojis"];
        [self save];
    }
    else
    {
        BOOL downloadMergeApp = [[localDic valueForKey:@"downloadMergeApp"] boolValue];
        if (!downloadMergeApp)
        {
            BOOL needShow = NO;
            NSString *rejectDateStr = [localDic objectForKey:@"kLastRejectDownloadDate"];
            int rejectCount = [[localDic objectForKey:@"kRejectownloadCount"] integerValue];
            if (rejectCount > 4)
            {
                return;
            }
            
            if (rejectDateStr == nil)
            {
                needShow = YES;
            }
            else
            {
                uint luanchUtc = [[NSDate dateFromStr:@"yyyyMMddHHmmss" time:rejectDateStr] timeIntervalSince1970];
                uint currentUtc = [[NSDate date] timeIntervalSince1970];
                if (currentUtc - luanchUtc > 60 * 2)
                {
                    needShow = YES;
                }
            }
            
            if (needShow)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🌟🌟Contacts Cleaner🌟🌟" message:@"Cleanup and Merge duplicate contacts with one tap, make your contacts well-organized,thousands of people love it!👏👏?" delegate:self cancelButtonTitle:@"😟Later" otherButtonTitles:@"😛Download", nil];
                alert.tag = 1005;
                [alert show];
            }
        }
    }
}

- (void)showMore3D
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🌟🌟Animated Emojis🌟🌟" message:@"Get 2000+ animated 3d emojis to prettify your messages, you can use them in iMessages,Email,WhatsApp and etc." delegate:self cancelButtonTitle:@"😟Later" otherButtonTitles:@"😛Download", nil];
    alert.tag = 1004;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1004)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/id740660941?mt=8"]];
        }
    }
    else if(alertView.tag == 1005)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/id680169170?mt=8"]];
            [localDic setValue:[NSNumber numberWithBool:YES] forKey:@"downloadMergeApp"];
            [self save];
        }
        else
        {
            int rejectCount = [[localDic objectForKey:@"kRejectownloadCount"] intValue];
            [localDic setObject:[NSNumber numberWithInt:++rejectCount] forKey:@"kRejectownloadCount"];
            [localDic setValue:[[NSDate date] stringFromDateFormat:@"yyyyMMddHHmmss"] forKey:@"kLastRejectDownloadDate"];
            [self save];
        }
    }
}

- (void)save
{
    [localDic writeToFile:[self spreadParamerter] atomically:YES];
}

- (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)spreadParamerter
{
    NSString *docPath = [self documentPath];
    NSString *path = [docPath stringByAppendingPathComponent:@"spreadAppParamerter.plist"];
    return path;
}

@end
