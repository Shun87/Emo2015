//
//  RateAppView.m
//  Smart Merge
//
//  Created by tsinglink on 15/11/2.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import "RateAppView.h"
#import "BaseAlertView.h"
#import "PureLayout.h"

#import "UIColor+HexColor.h"
#import "TTSocial.h"

#define kRateAppUrl     @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8"
#define kRateiOS7AppStoreURLFormat @"itms-apps://itunes.apple.com/app/id%@"

@interface RateAppView()
{
    UILabel *titleLabel;
    UILabel *detailLabel;
    NSArray *faceButtons;
    UIButton *rateButton;
    UIButton *feedbackButton;
    UIButton *closeButton;
    BaseAlertView *baseAlertView;
    TTSocial *socila;
}
@end

@implementation RateAppView

+(RateAppView *)sharedInstance
{
    static dispatch_once_t once;
    static RateAppView *s_userParameter = nil;
    dispatch_once(&once, ^{
        
        if (s_userParameter == nil)
        {
            s_userParameter = [[RateAppView alloc] init];
        }
    });
    
    return s_userParameter;
}

- (id)init
{
    if (self = [super init])
    {
        socila = [[TTSocial alloc] init];
        socila.viewController = [self appRootViewController];
    }
    
    return self;
}

- (void)showRateView
{
    if (![[UserParameter sharedInstance] needShowRateView])
    {
        return;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 220)];
    view.backgroundColor = [UIColor clearColor];
    
    titleLabel = [UILabel newAutoLayoutView];
    [view addSubview:titleLabel];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    titleLabel.numberOfLines = 0;
    titleLabel.preferredMaxLayoutWidth = 220;
    titleLabel.text = @"Hi there, what do you think about Contacts Cleaner?";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    detailLabel = [UILabel newAutoLayoutView];
    [view addSubview:detailLabel];
    [detailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:20.0];
    [detailLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    detailLabel.numberOfLines = 0;
    detailLabel.preferredMaxLayoutWidth = 240;
    detailLabel.font = [UIFont systemFontOfSize:18];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:button];
    [button setImage:[UIImage imageNamed:@"ReviewSad.png"] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(touchLessRegualar:)
     forControlEvents:UIControlEventTouchUpInside];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:button2];
    [button2 setImage:[UIImage imageNamed:@"ReviewRegular.png"] forState:UIControlStateNormal];
    [button2 addTarget:self
                action:@selector(touchGood:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:button3];
    [button3 setImage:[UIImage imageNamed:@"ReviewHappy.png"] forState:UIControlStateNormal];
    [button3 addTarget:self
                action:@selector(touchGood:)
      forControlEvents:UIControlEventTouchUpInside];
    
    faceButtons = @[button, button2, button3];
    
    [faceButtons autoSetViewsDimension:ALDimensionHeight toSize:75.0];
    [faceButtons autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0.0 insetSpacing:YES matchedSizes:YES];
    [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:detailLabel withOffset:30.0];


    
    feedbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    feedbackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:feedbackButton];
    [feedbackButton setTitle:@"Send feedback" forState:UIControlStateNormal];
    [feedbackButton addTarget:self
                   action:@selector(sendFeedback:)
         forControlEvents:UIControlEventTouchUpInside];
    [feedbackButton autoSetDimension:ALDimensionHeight toSize:30.0];
    [feedbackButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:detailLabel withOffset:30.0];
    [feedbackButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    feedbackButton.alpha = 0.0;
    [feedbackButton setTitleColor:[UIColor colorFromHex:0x2989dd] forState:UIControlStateNormal];
   [feedbackButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rateButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:rateButton];
    [rateButton setBackgroundImage:[[UIImage imageNamed:@"FlattButtonRounded"] stretchableImageWithLeftCapWidth:22 topCapHeight:20] forState:UIControlStateNormal];
    [rateButton setTitle:@"Rate" forState:UIControlStateNormal];
    [rateButton addTarget:self
                   action:@selector(rateApp:)
         forControlEvents:UIControlEventTouchUpInside];
    [rateButton autoSetDimension:ALDimensionHeight toSize:40.0];
    [rateButton autoSetDimension:ALDimensionWidth toSize:150.0];
    [rateButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:detailLabel withOffset:40.0];
    [rateButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    rateButton.alpha = 0.0;
    [rateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:closeButton];
    [closeButton setBackgroundImage:[[UIImage imageNamed:@"FlattButtonRounded"] stretchableImageWithLeftCapWidth:22 topCapHeight:20] forState:UIControlStateNormal];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self
                   action:@selector(closeView:)
         forControlEvents:UIControlEventTouchUpInside];
    [closeButton autoSetDimension:ALDimensionHeight toSize:40.0];
    [closeButton autoSetDimension:ALDimensionWidth toSize:150.0];
    [closeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:feedbackButton withOffset:30.0];
    [closeButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    closeButton.alpha = 0.0;
    
    baseAlertView = [[BaseAlertView alloc] init];
    baseAlertView.dismissBlock = ^{
    
        [[UserParameter sharedInstance]rejectRate];
    };
    [baseAlertView showCloseButton];
    [baseAlertView setContentView:view];
    [baseAlertView show];
}

- (IBAction)touchLessRegualar:(id)sender
{
    titleLabel.text = @"Thank you!";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    detailLabel.text = @"Would you like to email us your feedback?";
    for (int i=0; i<[faceButtons count]; i++)
    {
        UIButton *button = [faceButtons objectAtIndex:i];
        button.alpha = 0.0;
    }
    
    [UIView animateWithDuration:0.45 animations:^{
        closeButton.alpha = 1.0;
        feedbackButton.alpha = 1.0;
    }];
    
    [[UserParameter sharedInstance] rateUs];
}

- (IBAction)touchGood:(id)sender
{
    titleLabel.text = @"Thank you!";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    detailLabel.text = @"Could you please rate us on the App Store? We will do it better!";
    for (int i=0; i<[faceButtons count]; i++)
    {
        UIButton *button = [faceButtons objectAtIndex:i];
        button.alpha = 0.0;
    }
    
    [UIView animateWithDuration:0.45 animations:^{
        rateButton.alpha = 1.0;
    }];
}

- (IBAction)rateApp:(id)sender
{
    [self closeView:nil];
    [[UserParameter sharedInstance] rateUs];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[RateAppView appUrl]]];
}

- (IBAction)sendFeedback:(id)sender
{
    [baseAlertView dismissAlert:^{
        
        [socila sendFeedback:NSLocalizedString(@"Emoji Keyboard 3.0", nil) body:nil];
    }];
}

- (IBAction)closeView:(id)sender
{
    [baseAlertView dismissAlert:^{
    }];
    baseAlertView = nil;
}

+ (NSString *)appUrl
{
    NSString *rateUrl = @"itms://itunes.apple.com/us/app/id648963730?mt=8";
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f && [[UIDevice currentDevice].systemVersion floatValue] < 7.1f)
//    {
//        rateUrl = [NSString stringWithFormat:kRateiOS7AppStoreURLFormat, @"648963730"];
//    }
//    else
//    {
//        rateUrl = [NSString stringWithFormat:kRateAppUrl, @"648963730"];
//    }
    return rateUrl;
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
@end
