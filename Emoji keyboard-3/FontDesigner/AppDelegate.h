//
//  AppDelegate.h
//  FontDesigner
//
//  Created by chenshun on 13-5-5.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RateAppView.h"

#define FreeApp 1

#define kUnlockAll      @"com.cshun.FontDesignUnlockall"
#define kEmoticons      @"com.cshun.FontDesign.Unlockallemoticons"
#define kRmoveAds       @"com.cshun.FontDesign.RemoveAd"

#if FreeApp
#import <GoogleMobileAds/GoogleMobileAds.h>
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate
#if FreeApp
,GADBannerViewDelegate>
#else
>
#endif
{
    NSMutableArray *systemFontFamily;
#if FreeApp
     GADBannerView *adBanner;
#endif
}

@property (nonatomic, retain)NSMutableArray *systemFontFamily;
@property (strong, nonatomic) UIWindow *window;
#if FreeApp
@property (nonatomic, retain) GADBannerView *adBanner;
#endif
@property (strong, nonatomic) UITabBarController *tabBarController;

-(BOOL)showAds;
@end
