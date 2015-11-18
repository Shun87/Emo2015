//
//  AppDelegate.m
//  FontDesigner
//
//  Created by chenshun on 13-5-5.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "AppDelegate.h"

#import "SettingViewController.h"
#import "UIColor+HexColor.h"
#include "SymbolListViewController.h"
#import "FontPreviewController.h"
#import "ArtEmojiViewController.h"
#import "iRate.h"
#import "EmoticonViewController.h"
#import "EmoticonMainViewController.h"
#import "ArtViewController.h"
#import "FavoriteViewController.h"

@implementation AppDelegate
@synthesize systemFontFamily;
#if FreeApp
@synthesize adBanner;
#endif
- (void)dealloc
{
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    self.tabBarController = [[UITabBarController alloc] init];
    
    
    FontPreviewController *fontPreview = [[FontPreviewController alloc] initWithNibName:@"FontPreviewController" bundle:nil];
    UINavigationController *fontPreviewNav = [[UINavigationController alloc] initWithRootViewController:fontPreview];
    
    ArtEmojiViewController *artController = [[ArtEmojiViewController alloc] initWithNibName:@"ArtEmojiViewController" bundle:nil];
    UINavigationController *artControllerNav = [[UINavigationController alloc] initWithRootViewController:artController];

    EmoticonMainViewController *emoticonViewController = [[EmoticonMainViewController alloc] initWithNibName:@"EmoticonMainViewController" bundle:nil];
    UINavigationController *emoticonViewNav = [[UINavigationController alloc] initWithRootViewController:emoticonViewController];
    
    SettingViewController *viewController4 = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:viewController4];
    
    FavoriteViewController *artCotentController = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
    UINavigationController *artCotentControllerNav = [[UINavigationController alloc] initWithRootViewController:artCotentController];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: artControllerNav, fontPreviewNav, emoticonViewNav, artCotentControllerNav, settingNav, nil];
#if FreeApp

        // Initialize the banner at the bottom of the screen.
        CGPoint origin = CGPointMake(0.0, 0.0);
        GADAdSize gadSize = kGADAdSizeSmartBannerPortrait;
        self.adBanner = [[GADBannerView alloc] initWithAdSize:gadSize
                                                        origin:origin];
        self.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.adBanner.adUnitID = @"ca-app-pub-2517211357606902/9103665272";
        self.adBanner.delegate = self;
        [self.adBanner setRootViewController:self.tabBarController];
        [self.adBanner loadRequest:[self createRequest]];
    
#else
#endif

    self.window.rootViewController = self.tabBarController;
    
    [iRate sharedInstance].applicationBundleID = @"com.cshun.FontDesignFree";
	[iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].usesUntilPrompt = 3;
    [iRate sharedInstance].daysUntilPrompt = 0.5;
    
    return YES;
}

#if FreeApp
// Here we're creating a simple GADRequest and whitelisting the application
// for test ads. You should request test ads during development to avoid
// generating invalid impressions and clicks.
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];

#if DEBUG
    request.testDevices = @[
                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
                            ];
#endif
    return request;
}

#pragma mark GADBannerViewDelegate impl
// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

#endif
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
