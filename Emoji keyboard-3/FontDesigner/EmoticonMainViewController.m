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
    
    self.navigationItem.title = NSLocalizedString(@"Emoticon", nil);
    array = [[NSMutableArray alloc] init];
    mTableView.rowHeight = 65;

    countPerRow = 3;
    NSString *model = [UIDevice currentDevice].model;
    if ([model hasPrefix:@"iPad"] || [model hasSuffix:@"iPad"])
    {
        countPerRow = 5;
    }
    
    segment = [[UISegmentedControl alloc] initWithItems:@[@"Static", @"Animated"]];
    segment.selectedSegmentIndex = 0;
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [segment addTarget:self
            action:@selector(selectIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segment;
    [self selectIndexChanged:nil];
}

- (IBAction)selectIndexChanged:(id)sender
{
    [array removeAllObjects];
    [imageArray removeAllObjects];
    if (segment.selectedSegmentIndex == 0)
    {
        [self reloadEmoticons:@"PRO" count:-1];
    }
    else
    {
        [self reloadEmoticons:@"Animated" count:-1];
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
    
    BOOL access = YES;
    NSIndexPath *indexPath = [mTableView indexPathForCell:tableCell];
    
        NSInteger dirIndex = [indexPath row] * countPerRow + index;
        if (dirIndex < [array count])
        {
            NSString *dirName = [array objectAtIndex:dirIndex];
            EmoticonViewController *emotionViewController = [[EmoticonViewController alloc] initWithNibName:@"EmoticonViewController" bundle:nil];
            emotionViewController.emtionTitle = dirName;
            emotionViewController.selectIndex = dirIndex;
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

        CGRect rect = app.adBanner.frame;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        app.adBanner.frame = rect;
        app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:app.adBanner];

    
    
        self.navigationItem.rightBarButtonItem = nil;
    
    
#endif
    [mTableView reloadData];
    
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
    return [imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (segment.selectedSegmentIndex == 1)
        {
                cell = [[EmoticonCell alloc] initWithImageCount:countPerRow style:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        else{
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }

        {
            OLImageView *imageView2 = [[OLImageView alloc] init];
            [imageView2 setFrame:CGRectMake(10, 0, 65, 65)];
            imageView2.backgroundColor = [UIColor clearColor];
            imageView2.userInteractionEnabled = YES;
            imageView2.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:imageView2];
            imageView2.tag = 1001;
            
            UILabel *label = [[UILabel alloc] init];
            [label setFrame:CGRectMake(95, 0, cell.frame.size.width-95, cell.frame.size.height)];
            [cell.contentView addSubview:label];
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            label.tag = 1002;

        }
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    OLImageView *imageView = (OLImageView *)[cell.contentView viewWithTag:1001];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1002];
    
    NSString *path = [imageArray objectAtIndex:[indexPath row]];
    NSData *gifData2 = [NSData dataWithContentsOfFile:path];
    imageView.image = [OLImage imageWithData:gifData2];
    label.text = [array objectAtIndex:[indexPath row]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger dirIndex = [indexPath row];

    NSString *dirName = [array objectAtIndex:dirIndex];
    EmoticonViewController *emotionViewController = [[EmoticonViewController alloc] initWithNibName:@"EmoticonViewController" bundle:nil];
    emotionViewController.emtionTitle = dirName;
    emotionViewController.selectIndex = dirIndex;
    emotionViewController.animated = (segment.selectedSegmentIndex == 1);
    [self.navigationController pushViewController:emotionViewController animated:YES];
    
}

@end
