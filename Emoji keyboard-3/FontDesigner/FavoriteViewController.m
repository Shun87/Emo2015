//
//  FavoriteViewController.m
//  Emoji keyboard
//
//  Created by tsinglink on 15/11/16.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import "FavoriteViewController.h"
#import "ArtViewController.h"
#import "EmoticonViewController.h"
#import "AppDelegate.h"

@interface FavoriteViewController ()
{
    ArtViewController *artCotentController;
    EmoticonViewController *emotionViewController;
    UISegmentedControl *segment;
    BOOL editMode;
}
@end

@implementation FavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Favorites";
        self.tabBarItem.image = [UIImage imageNamed:@"favorite.png"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    
    segment = [[UISegmentedControl alloc] initWithItems:@[@"Text Art", @"Emoji"]];
    segment.selectedSegmentIndex = 0;
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [segment addTarget:self
                action:@selector(selectIndexChanged:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;

    artCotentController = [[ArtViewController alloc] initWithNibName:@"ArtViewController" bundle:nil];
    artCotentController.showIndex = nil;
    artCotentController.viewController = self;
    [self.view addSubview:artCotentController.view];
    artCotentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(startEdit:)];
}

- (IBAction)startEdit:(id)sender
{
    editMode = !editMode;
    if (editMode)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(startEdit:)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(startEdit:)];
    }
    
    if (artCotentController != nil)
    {
        [artCotentController startEding:editMode];
    }
    
    if (emotionViewController != nil)
    {
        [emotionViewController startEding:editMode];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (artCotentController != nil)
    {
        [artCotentController showArtText:nil];
        [artCotentController loadAd];
    }
    
    if (emotionViewController != nil)
    {
        [emotionViewController localEmoji];
        [emotionViewController loadAd];
    }
    
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
}

- (IBAction)selectIndexChanged:(id)sender
{
    if (editMode)
    {
        [self startEdit:nil];
    }
    
    if (segment.selectedSegmentIndex == 0)
    {
        [emotionViewController.view removeFromSuperview];
        emotionViewController = nil;
        
        if (artCotentController == nil)
        {
            artCotentController = [[ArtViewController alloc] initWithNibName:@"ArtViewController" bundle:nil];
            artCotentController.showIndex = nil;
            artCotentController.viewController = self;
            artCotentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
        [self.view addSubview:artCotentController.view];
        artCotentController.view.frame = self.view.bounds;
        [artCotentController showArtText:nil];
        [artCotentController loadAd];
    }
    else
    {
        [artCotentController.view removeFromSuperview];
        artCotentController = nil;
        
        if (emotionViewController == nil)
        {
            emotionViewController = [[EmoticonViewController alloc] initWithNibName:@"EmoticonViewController" bundle:nil];
            emotionViewController.localFavorite = YES;
            emotionViewController.viewController = self;
            emotionViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        }
 
        [self.view addSubview:emotionViewController.view];
        emotionViewController.view.frame = self.view.bounds;
        [emotionViewController localEmoji];
        [emotionViewController loadAd];
    }
    
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
