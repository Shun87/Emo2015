//
//  RateAppView.h
//  Smart Merge
//
//  Created by tsinglink on 15/11/2.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserParameter.h"

@interface RateAppView : UIView
+(RateAppView *)sharedInstance;
- (void)showRateView;
+ (NSString *)appUrl;
@end
