//
//  ArtViewController.m
//  CustomEmoji
//
//  Created by chenshun on 13-7-6.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "ArtViewController.h"

#import "Love.h"
#import "Celebration.h"
#import "Hello.h"
#import "Smiley.h"
#import "Val.h"
#import "Bir.h"
#import "holiday.h"
#import "Food.h"
#import "Fun.h"
#import "Lifestyle.h"
#import "Nature.h"
#import "UIColor+HexColor.h"
#import "AppDelegate.h"

@interface ArtViewController ()
{
    BOOL editMode;
}

@property (nonatomic, strong)NSMutableArray *localCacheArray;
@end

@implementation ArtViewController
@synthesize title, aText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showByFontKeyboard = NO;
        self.tabBarItem.title = @"Favorites";
        self.tabBarItem.image = [UIImage imageNamed:@"favorite.png"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if FreeApp

    [self loadAd];
    
#else
    mTableView.frame = self.view.bounds;
#endif
    
}

- (void)loadAd
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.adBanner.superview != nil)
    {
        [app.adBanner removeFromSuperview];
    }
    
    if ([app showAds])
    {
        CGRect rect = mTableView.frame;
        rect.size.height = self.view.bounds.size.height - app.adBanner.frame.size.height - 8;
        mTableView.frame = rect;
        
        rect = app.adBanner.frame;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        app.adBanner.frame = rect;
        app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:app.adBanner];
    }
    else
    {
        app.adBanner = nil;
        mTableView.frame = self.view.bounds;
    }
}

- (void)showArtText:(NSString *)text
{
    [textArray removeAllObjects];
    NSMutableArray *array = nil;
    BOOL convert = YES;
    if ([text isEqualToString:@"Greetings"])
    {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *dir = [bundlePath stringByAppendingPathComponent:@"Greeting"];
        NSArray *gifDirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
        for (int k=0; k<[gifDirArray count]; k++)
        {
            NSString *filePath = [gifDirArray objectAtIndex:k];
            filePath = [dir stringByAppendingPathComponent:filePath];
            NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            [textArray addObject:text];
        }
        convert = NO;
    }
    else if ([text isEqualToString:@"Gesture"])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmojiArtGestures.plist" ofType:nil];
        array = [NSMutableArray arrayWithContentsOfFile:path];
        convert = NO;
    }
    else if ([text isEqualToString:@"Weather"])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmojiArtWeather.plist" ofType:nil];
        array = [NSMutableArray arrayWithContentsOfFile:path];
        convert = NO;
    }
    else if ([text isEqualToString:@"Sport"])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmojiArtSports.plist" ofType:nil];
        array = [NSMutableArray arrayWithContentsOfFile:path];
        convert = NO;
    }
    else if ([text isEqualToString:@"Symbol"])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmojiArtSymbols.plist" ofType:nil];
        array = [NSMutableArray arrayWithContentsOfFile:path];
        convert = NO;
    }
    else if ([text isEqualToString:@"Fun"])
    {
        array = [NSMutableArray arrayWithObjects:fun1,fun2,fun3,fun4,fun5,fun6,fun7,fun8,fun9,fun10,fun11,fun12,fun13,fun14,fun15,fun16,fun17,fun18,fun19,fun20, nil];
    }
    else if ([text isEqualToString:@"Food"])
    {
        array = [NSMutableArray arrayWithObjects:food1,food2,food3,food4,food5,food6,food7,food8,food9,food10,food11,food12,food13,food14,food15,food16,food17,food18,food19,food20,food21,food22,food23,food24, nil];
    }
    else if ([text isEqualToString:@"Lifestyle"])
    {
        array = [NSMutableArray arrayWithObjects:lifestyle1,lifestyle2,lifestyle3,lifestyle4,lifestyle5,lifestyle6,lifestyle7,lifestyle8,lifestyle9,lifestyle10,lifestyle11,lifestyle12,lifestyle13,lifestyle14,lifestyle15,lifestyle16, nil];
    }
    else if ([text isEqualToString:@"Nature"])
    {
        array = [NSMutableArray arrayWithObjects:nature1,nature2,nature3,nature4,nature5,nature6,nature7,nature8,nature9,nature10,nature11,nature12,nature13,nature14,nature15,nature16,nature17,nature18,nature19,nature20,nature21,nature22,nature23,nature24,nature25, nature26,nature27,nature28,nature29, nature30,nature31,nature32,nil];
    }
    else if ([text isEqualToString:@"Love"])
    {
        array = [NSMutableArray arrayWithObjects:love1,love2,love3,love4,love5,love6,love7,love8,love9,love10,love11,love12,love13,love14,love15,love16,love17,love18,love19,love20,love21,love22,love23,love24,love25,love26,love27, nil];
    }
    else if ([text isEqualToString:@"Celebration"])
    {
        array = [NSMutableArray arrayWithObjects:c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11, nil];
    }
    else if ([text isEqualToString:@"Smiley Icon"])
    {
        array = [NSMutableArray arrayWithObjects:smile1,smile2,smile3,smile4,smile5,smile6,smile7,smile8,smile9,smile10,smile11,smile12,smile13,smile14,smile15,smile16,smile17,smile18,smile19,smile20,hello22,nil];
    }
    else if ([text isEqualToString:@"Christmas"])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Christmas.plist" ofType:nil];
        array = [NSMutableArray arrayWithContentsOfFile:path];
        convert = NO;
        
    }
    else if ([text isEqualToString:@"Valentine"])
    {
        array = [NSMutableArray arrayWithObjects:va1,va2,va3,va4,va5,va6,va7,va8,va9,va10,va11,va12,va13,va14,va15,va16,nil];
    }
    else if ([text isEqualToString:@"Birthday"])
    {
        array = [NSMutableArray arrayWithObjects:bir1,bir2,bir3,bir4,bir5,bir6,bir7,bir8,bir9,nil];
    }
    else if ([text isEqualToString:@"Holiday"])
    {
        array = [NSMutableArray arrayWithObjects:ho1,ho2,ho3,ho4,ho5,ho6,ho7,ho8,ho9,ho10,ho11,ho12,ho13, ho14,nil];
    }
    else if (text == nil)
    {
        [self.localCacheArray removeAllObjects];
        array = [NSMutableArray array];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Favorites_Text.plist"];
        NSArray *textArts = [NSMutableArray arrayWithContentsOfFile:path];
        if ([textArts count] > 0)
        {
            [array addObjectsFromArray:textArts];
        }
        
        convert = NO;
    }
    
    if (!convert)
    {
        [textArray addObjectsFromArray:array];
    }
    else
    {
        for (int i=0; i<[array count]; i++)
        {
            NSString *text = [array objectAtIndex:i];
            
            NSString *chinese = @"";
            if (text != nil && convert)
            {
                NSArray *array = [text componentsSeparatedByString:@" "];
                for (int i=0; i<[array count]; i++)
                {
                    NSString *unicode = [array objectAtIndex:i];
                    unicode = [unicode uppercaseString];
                    
                    unicode = [unicode stringByReplacingOccurrencesOfString:@"\\U" withString:@""];
                    ushort hex = (ushort)strtol([unicode UTF8String], 0, 16);
                    NSData *data4 = [NSData dataWithBytes:&hex length:sizeof(ushort)];
                    NSString *text = [[NSString alloc] initWithData:data4
                                                            encoding:NSUTF16LittleEndianStringEncoding];
                    chinese = [chinese stringByAppendingFormat:@"%@", text];
                    
                }
            }
            else
            {
                chinese = text;
            }
            
            [textArray addObject:chinese];
        }
    }
    
    [mTableView reloadData];
}

- (void)deleteTextAt:(BubbleView *)bubble
{
    if (editMode)
    {
        UIView *view = bubble.superview;
        while (![NSStringFromClass([view class]) isEqualToString:@"UITableViewCell"])
        {
            view = [view superview];
        }
        UITableViewCell *cell = (UITableViewCell *)view;
        NSIndexPath *indexPath = [mTableView indexPathForCell:cell];
        NSInteger row = [indexPath row];
        if (row > [textArray count])
        {
            return;
        }
        
        [textArray removeObjectAtIndex:row];
        [mTableView reloadData];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Favorites_Text.plist"];
        [textArray writeToFile:path atomically:YES];
    }
}

- (void)selectBubble:(BubbleView *)bubble
{
    self.aText = bubble.text;
    CGRect rect = [scrollView convertRect:bubble.frame toView:self.view];
    UIActionSheet *actionSheet = nil;
    BOOL showActionSheet = NO;
    BOOL showFavorite = NO;
    if (self.showIndex != nil)
    {
        showActionSheet = YES;
    }
    else
    {
        // 收藏
        showActionSheet = YES;
        showFavorite = YES;
    }

 
    
    if (showFavorite)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"SMS", nil),
                       NSLocalizedString(@"Email", nil),
                       NSLocalizedString(@"Copy", nil),
                       
                       nil];
    }
    else
    {
        if (self.showByFontKeyboard)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kSelectBubbuleText" object:self.aText userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"SMS", nil),
                           NSLocalizedString(@"Email", nil),
                           NSLocalizedString(@"Add to Favorites", nil),
                           NSLocalizedString(@"Copy", nil),
                           
                           nil];
        }

    }

    if (actionSheet != nil)
    {
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
}

- (NSString *)fileName
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMdd-HH-mm-ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)saveText
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Favorites_Text.plist"];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithContentsOfFile:path];
    if ([mutableArray count] == 0)
    {
        mutableArray = [[NSMutableArray alloc] init];
    }

    [mutableArray addObject:self.aText];
    [mutableArray writeToFile:path atomically:YES];
}

- (void)startEding:(BOOL)edit
{
    editMode = edit;
    [mTableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [social showSMSPicker:self.aText phones:nil];
    }
    else if (buttonIndex == 1)
    {
        [social showMailPicker:self.aText to:nil cc:nil bcc:nil images:nil];
    }
    else if (buttonIndex == 2)
    {
        if (self.showIndex != nil)
        {
            [self saveText];
        }
        else
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.aText;
        }
    }
    else if (buttonIndex == 3)
    {
        if (self.showIndex != nil)
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.aText;
        }
    }
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
    self.view.backgroundColor = [UIColor colorFromHex:TableViewBKColor];
    
    textArray = [[NSMutableArray alloc] init];
    mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    self.navigationItem.title = title;
    
    social = [[TTSocial alloc] init];
    if (self.viewController != nil)
    {
        social.viewController = self.viewController;
    }
    else
    {
        social.viewController = self;
    }
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"back_white.png"] forState:UIControlStateNormal];
//    [button setFrame:CGRectMake(0, 0, 40, 40)];
//    button.showsTouchWhenHighlighted = YES;
//    [button addTarget:self
//               action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = leftItem;
    [self showArtText:self.showIndex];
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [textArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [textArray objectAtIndex:[indexPath row]];
    CGSize bubbleSize = [BubbleView bubbleSizeForText:text];
    return bubbleSize.height + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NavCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        
        BubbleView *bubbleView = [[BubbleView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width
                                                                               , cell.bounds.size.height-5)];
        bubbleView.delegate = self;
        bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        bubbleView.tag = 1000;
        [cell.contentView addSubview:bubbleView];
    }
    
    BubbleView *bubbleView = (BubbleView *)[cell.contentView viewWithTag:1000];
    NSString *text = [textArray objectAtIndex:[indexPath row]];

    bubbleView.text = text;
    bubbleView.editMode = editMode;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)dealloc
{
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
