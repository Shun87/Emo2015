//
//  ArtEmojiViewController.m
//  CustomEmoji
//
//  Created by chenshun on 13-7-6.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "ArtEmojiViewController.h"
#import "BubbleView.h"
#import "ArtViewController.h"
#import "AppDelegate.h"
#import "UIColor+HexColor.h"
#import "FontPreviewController.h"
#import "SettingViewController.h"
#import "EmoticonViewController.h"

@interface ArtEmojiViewController ()

@end

@implementation ArtEmojiViewController

- (void)dealloc
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Emoji Art", @"Family");
        self.tabBarItem.image = [UIImage imageNamed:@"emoji.png"];
        self.showPromtAd = YES;
        self.showByFontKeyboard = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        self.tabBarController.tabBar.translucent = NO;
    }
#endif
    self.navigationController.navigationBar.translucent = NO;

    aTableView.rowHeight = 65;
    array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:@[
                                 
                                 @"Greetings",
                                 @"Christmas",
                                 @"Gesture",
                                 @"Weather",
                                 @"Sport",
                                 @"Symbol",
                                 @"Fun",
                                 @"Food",
                                 @"Lifestyle",
                                 @"Nature",
                                 @"Love",
                                 @"Celebration",
                                 @"Smiley Icon",
                                 @"Valentine",
                                 @"Birthday",
                                 @"Holiday",
                                 ]
     ];
}

- (IBAction)upgradeAction2:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome feature!" message:@"Upgrade to pro version to have more cute emojis emoticons, symbols and fonts, link them to your iPhone/iPad,And No Ads!" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Upgrade", nil];
    [alert show];
    alert.tag = 1000;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/id662538696?mt=8"]];
    }
}

- (IBAction)upgradeAction:(id)sender
{

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if FreeApp
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.adBanner.superview != nil)
    {
        [app.adBanner removeFromSuperview];
    }
    
    if ([app showAds])
    {
        CGRect rect = app.adBanner.frame;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        app.adBanner.frame = rect;
        app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:app.adBanner];
    }
    else
    {
        app.adBanner = nil;
        aTableView.frame = self.view.bounds;
    }
    
#endif
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
}

- (IBAction)settingView:(id)sender
{
    SettingViewController *settingController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)showArt:(NSString *)index
{
    ArtViewController *artController = [[ArtViewController alloc] initWithNibName:@"ArtViewController" bundle:nil];
    artController.hidesBottomBarWhenPushed = YES;
    if (index == nil)
    {
        artController.title = NSLocalizedString(@"Favorites", nil);
    }
    else
    {
        artController.title = index;
    }
    artController.showIndex = index;
    artController.showByFontKeyboard = self.showByFontKeyboard;
    [self.navigationController pushViewController:artController animated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *text = [array objectAtIndex:[indexPath row]];
    cell.textLabel.text = text;

    NSString *imageName = nil;
    NSInteger row = [indexPath row];
    if ([text isEqualToString:@"Greetings"])
    {
        imageName = @"Greeting_Emo.jpg";
    }
    else if ([text isEqualToString:@"Gesture"])
    {
        imageName = @"Gesture_Emo.jpg";
    }
    else if ([text isEqualToString:@"Weather"])
    {
        imageName = @"Weather_Emo.jpg";
    }
    else if ([text isEqualToString:@"Sport"])
    {
        imageName = @"Sport_Emo.jpg";
    }
    else if ([text isEqualToString:@"Symbol"])
    {
        imageName = @"Symbol_Emo.jpg";
    }
    else if ([text isEqualToString:@"Fun"])
    {
        imageName = @"Fun_Emo.jpg";
    }
    else if ([text isEqualToString:@"Food"])
    {
        imageName = @"Food_Emo.jpg";
    }
    else if ([text isEqualToString:@"Lifestyle"])
    {
        imageName = @"Life_Emo.jpg";
    }
    else if ([text isEqualToString:@"Nature"])
    {
        imageName = @"Nature_Emo.jpg";
    }
    else if ([text isEqualToString:@"Love"])
    {
        imageName = @"Love_Emo.jpg";
    }
    else if ([text isEqualToString:@"Celebration"])
    {
        imageName = @"Celebration_Emo.jpg";
    }
    else if ([text isEqualToString:@"Smiley Icon"])
    {
        imageName = @"Mood_Emo.jpg";
    }
    else if ([text isEqualToString:@"Christmas"])
    {
        imageName = @"Christmas_Emo.jpg";
    }
    else if ([text isEqualToString:@"Valentine"])
    {
        imageName = @"City_Emo.jpg";
    }
    else if ([text isEqualToString:@"Birthday"])
    {
        imageName = @"Gesture_Emo.jpg";
    }
    else if ([text isEqualToString:@"Holiday"])
    {
        imageName = @"School_Emo.jpg";
    }

    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text = [array objectAtIndex:[indexPath row]];
    [self showArt:text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
