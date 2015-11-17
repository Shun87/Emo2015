//
//  UserParameter.h
//  Smart Merge
//
//  Created by tsinglink on 15/11/2.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserParameter : NSObject
+(UserParameter *)sharedInstance;

- (BOOL)needShowRateView;
- (void)rateUs;
- (void)rejectRate;

- (void)doSwitchAction;
@end
