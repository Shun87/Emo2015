//
//  EmoticonViewController.m
//  Characters
//
//  Created by chenshun on 13-7-8.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "EmoticonMainViewController.h"
#import "AppDelegate.h"
#import "OLImage.h"
#import "UIColor+HexColor.h"
#import "EmoticonViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "UpgradeViewController.h"
#import "InAppRageIAPHelper.h"
@interface EmoticonMainViewController ()

@end

@implementation EmoticonMainViewController
@synthesize image;

- (void)dealloc{
    [mTableView release];
    [upgradeButton release];
    [array release];
    [image release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Emoticon", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"image.png"];
        array = [[NSMutableArray alloc] init];
        imageArray = [[NSMutableArray alloc] init];
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
#if FreeApp
    self.navigationItem.rightBarButtonItem = upgradeButton;
#endif
    self.navigationItem.title = NSLocalizedString(@"Emoticon", nil);
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    array = [[NSMutableArray alloc] init];
    mTableView.rowHeight = 140;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    
    [array addObject:@"Small Black"];
    [array addObject:@"Popo"];
    [array addObject:@"Christmas"];
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *dir = [bundlePath stringByAppendingPathComponent:@"PRO"];
    NSArray *gifDirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
    for (int i=0; i<[gifDirArray count]; i++)
    {
        NSString *gifDirName = [gifDirArray objectAtIndex:i];
        if (![array containsObject:gifDirName]){
            [array addObject:gifDirName];
        }
    }
    
    for (int i=0; i<[array count]; i++)
    {
        NSString *gifDirPath = [dir stringByAppendingPathComponent:[array objectAtIndex:i]];
        NSArray *gifPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:gifDirPath error:nil];
        if ([gifPaths count] > 0)
        {
            NSString *gifFileName = [gifPaths objectAtIndex:0];
            NSString *gifFilePath = [gifDirPath stringByAppendingPathComponent:gifFileName];
            [imageArray addObject:gifFilePath];
        }
    }

    
    countPerRow = 3;
    NSString *model = [UIDevice currentDevice].model;
    if ([model hasPrefix:@"iPad"] || [model hasSuffix:@"iPad"])
    {
        countPerRow = 5;
    }
}

- (IBAction)helpAction:(id)sender
{
    HelpViewController *helpView = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:helpView animated:YES];
    [helpView release];
}

- (IBAction)upgradeAction:(id)sender
{
    UpgradeViewController *upgradeViewController = [[UpgradeViewController alloc] initWithNibName:@"UpgradeViewController" bundle:nil];
    upgradeViewController.lastController = self;
    UINavigationController *upgradeViewControllerNav = [[UINavigationController alloc] initWithRootViewController:upgradeViewController];
    [self presentModalViewController:upgradeViewControllerNav animated:YES];
    [upgradeViewController release];
    [upgradeViewControllerNav release];

}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectImage:(UIImage *)aimage at:(NSInteger)index cell:(UITableViewCell *)tableCell
{
    if (aimage == nil)
    {
        return;
    }
    
    BOOL access = YES;
    NSIndexPath *indexPath = [mTableView indexPathForCell:tableCell];
    if ([indexPath row] >= 1)
    {
        BOOL unlockAll = [[[NSUserDefaults standardUserDefaults] valueForKey:kUnlockAll] boolValue];
        BOOL buyEmoticon = [[[NSUserDefaults standardUserDefaults] valueForKey:kEmoticons] boolValue];
        if (unlockAll || buyEmoticon)
        {
            access = YES;
        }
    }
    else
    {
        access = YES;
    }
    
    if (access)
    {
        NSInteger dirIndex = [indexPath row] * countPerRow + index;
        if (dirIndex < [array count])
        {
            NSString *dirName = [array objectAtIndex:dirIndex];
            EmoticonViewController *emotionViewController = [[[EmoticonViewController alloc] initWithNibName:@"EmoticonViewController" bundle:nil] autorelease];
            emotionViewController.emtionTitle = dirName;
            emotionViewController.selectIndex = dirIndex;
            [self.navigationController pushViewController:emotionViewController animated:YES];
        }
    }
    else
    {
        UpgradeViewController *upgradeViewController = [[UpgradeViewController alloc] initWithNibName:@"UpgradeViewController" bundle:nil];
        UINavigationController *upgradeViewControllerNav = [[UINavigationController alloc] initWithRootViewController:upgradeViewController];
        upgradeViewController.lastController = self;
        [self presentModalViewController:upgradeViewControllerNav animated:YES];
        [upgradeViewController release];
        [upgradeViewControllerNav release];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.image = self.image;
        
        BOOL promt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"promted"] boolValue];
        if (!promt)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"To send a emoticon picture:1.Tap emoticon 2.Choose the recipient(must have iMessage or MMS) \n 3.Tap and hold message field to Paste 4.Send"
                                                           delegate:(id <UIAlertViewDelegate>)self
                                                  cancelButtonTitle:@"Don't promt again"
                                                  otherButtonTitles:@"Send", nil];
            [alert show];
        }
        else
        {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
        }
        
    }
    else if (buttonIndex == 1)
    {
        [social showMailPicker:nil to:nil cc:nil bcc:nil images:[NSArray arrayWithObjects:self.image, nil]];
    }
    else if (buttonIndex == 2)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.image = self.image;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"promted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
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
    BOOL buyed = [[[NSUserDefaults standardUserDefaults] valueForKey:kRemoveAd] boolValue];
    BOOL unlockAll = [[[NSUserDefaults standardUserDefaults] valueForKey:kUnlockAll] boolValue];
    if (!buyed && !unlockAll)
    {
        CGRect rect = app.adBanner.frame;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        app.adBanner.frame = rect;
        app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:app.adBanner];
    }
    else
    {
        mTableView.frame = self.view.bounds;
    }
    
#else
    mTableView.frame = self.view.bounds;
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imageArray count] / countPerRow + ([imageArray count] % countPerRow == 0 ? 0 : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    EmoticonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EmoticonCell alloc] initWithImageCount:countPerRow style:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        
        float width = cell.bounds.size.width;
        NSString *model = [UIDevice currentDevice].model;
        if ([model hasPrefix:@"iPad"] || [model hasSuffix:@"iPad"])
        {
            width = 768;
        }
        float left = (width - 106 * countPerRow ) / (countPerRow + 1);
        CGRect rect = CGRectMake(left, 8, 106, 106);
        
        for (int i=0; i<countPerRow; i++)
        {
            UILabel *label = [[[UILabel alloc] init] autorelease];
            CGRect labelRect = rect;
            labelRect.origin.y = 100;
            labelRect.size.height = 20;
            [label setFrame:labelRect];
            [cell.contentView addSubview:label];
            
            label.tag = 1000 + i;
            label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            
 
            rect.origin.x += left + 106;
        }
        
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = [indexPath row];
    NSRange range;
    range.location = countPerRow * row;
    range.length = countPerRow;
    if (range.location + range.length > [imageArray count])
    {
        range.length = [imageArray count] - range.location;
    }
    [cell setImages:[imageArray subarrayWithRange:range]];
    
    
    for (int i=0; i<countPerRow; i++)
    {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:1000 + i];
        label.text = nil;
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:2000 + i];
        imageView.image = nil;
    }
    
    NSArray *textArray = [array subarrayWithRange:range];
    for (int i=0; i<[textArray count]; i++)
    {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:1000 + i];
        label.text = [textArray objectAtIndex:i];
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:2000 + i];
        imageView.image = [UIImage imageNamed:@"SelectButtonSilver.png"];
    }
    
    return cell;
}

@end
