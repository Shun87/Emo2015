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

#import "OLImageView.h"
#import "NSDate+Additions.h"
#import "ModalSpreadApp.h"

@interface EmoticonMainViewController ()

@end

@implementation EmoticonMainViewController
@synthesize image;

- (void)dealloc{

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Emoticon", nil);
    array = [[NSMutableArray alloc] init];
    mTableView.rowHeight = 140;
    mTableView.backgroundColor = [UIColor whiteColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    countPerRow = 4;
    segment = [[UISegmentedControl alloc] initWithItems:@[ @"Gif", @"Stickers"]];
    segment.selectedSegmentIndex = 0;
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [segment addTarget:self
            action:@selector(selectIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segment;
    [self selectIndexChanged:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More 3D" style:UIBarButtonItemStyleBordered target:self action:@selector(showMore3DByManual:)];

}

- (void)showOtherApp
{
    [[ModalSpreadApp sharedInstance] showOtherApp];
}

- (IBAction)showMore3DByManual:(id)sender
{
    [[ModalSpreadApp sharedInstance] showMore3D];
}

- (IBAction)selectIndexChanged:(id)sender
{
    [array removeAllObjects];
    [imageArray removeAllObjects];
    if (segment.selectedSegmentIndex == 0)
    {
        [self reloadEmoticons:@"Animated" count:-1];
    }
    else
    {
        [self reloadEmoticons:@"PRO" count:-1];
    }
    [mTableView reloadData];
}

- (void)reloadEmoticons:(NSString *)dirName count:(NSInteger)cnt
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *dir = [bundlePath stringByAppendingPathComponent:dirName];
    NSArray *gifDirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
    NSInteger readyCnt = cnt;
    if (readyCnt < 0)
    {
        readyCnt = [gifDirArray count];
    }
    for (int i=0; i<readyCnt; i++)
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
}

- (IBAction)helpAction:(id)sender
{
    HelpViewController *helpView = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:helpView animated:YES];

}

- (IBAction)upgradeAction:(id)sender
{
    
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
    
    NSIndexPath *indexPath = [mTableView indexPathForCell:tableCell];
    NSInteger dirIndex = [indexPath row] * countPerRow + index;
    if (dirIndex < [array count])
    {
        NSString *dirName = [array objectAtIndex:dirIndex];
        EmoticonViewController *emotionViewController = [[EmoticonViewController alloc] initWithNibName:@"EmoticonViewController" bundle:nil];
        emotionViewController.emtionTitle = dirName;
        emotionViewController.selectIndex = dirIndex;
        emotionViewController.animated = (segment.selectedSegmentIndex == 0);
        [self.navigationController pushViewController:emotionViewController animated:YES];
    }

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
        mTableView.frame = self.view.bounds;
        app.adBanner = nil;
    }


#endif
    [mTableView reloadData];
    
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
    
    [self performSelector:@selector(showOtherApp) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)resizeImage:(UIImage *)aimage
{
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    [aimage drawInRect:rect];
    
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundedImage;
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
    if (cell == nil)
    {
        cell = [[EmoticonCell alloc] initWithImageCount:countPerRow style:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.delegate = self;
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
    NSArray *textArray = [array subarrayWithRange:range];
    [cell setImages:[imageArray subarrayWithRange:range] text:textArray];
    
    return cell;
}

@end
