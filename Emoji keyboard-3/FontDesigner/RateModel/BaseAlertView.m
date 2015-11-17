//
//  DeviceConnectViewController.m
//  iMyCamera
//
//  Created by chenshun on 14-2-17.
//  Copyright (c) 2014年 MacBook. All rights reserved.
//

#import "BaseAlertView.h"
#import "UIColor+HexColor.h"

@interface BaseAlertView ()
{
    BOOL showCloseButton;
}
@property (nonatomic, strong) UIView *backImageView;

@end

@implementation BaseAlertView
@synthesize selfSize;

- (id)init
{
    if (self  = [super init])
    {
        self.selfSize = CGSizeMake(280, 220);
        UIViewController *topVC = [self appRootViewController];
        
        if (!self.backImageView) {
            self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
            self.backImageView.backgroundColor = [UIColor blackColor];
            self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
        [topVC.view addSubview:self.backImageView];
        self.backImageView.alpha = 0.0f;
        
        self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.selfSize.width) * 0.5, CGRectGetHeight(topVC.view.bounds), self.selfSize.width, self.selfSize.height);
        [topVC.view addSubview:self];
    }
    
    return self;
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.selfSize.width) * 0.5, (CGRectGetHeight(topVC.view.bounds) - self.selfSize.height) * 0.5, self.selfSize.width, self.selfSize.height);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.backImageView.alpha = 0.75;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissAlert:(dispatch_block_t)block
{
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.selfSize.width) * 0.5, CGRectGetHeight(topVC.view.bounds), self.selfSize.width, self.selfSize.height);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.backImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backImageView removeFromSuperview];
        self.backgroundColor = nil;
        if (block) {
            block();
        }
    }];
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

- (void)showCloseButton
{
    showCloseButton = YES;
}

- (IBAction)dismissAction:(id)sender
{
    [self dismissAlert:^{
        if (self.dismissBlock)
        {
            self.dismissBlock();
        }
    }];
}

- (void)setContentView:(UIView *)contentView
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat padding = 15.0;
    CGFloat top = padding;
    if (showCloseButton)
    {
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(self.frame.size.width - 36, 0, 32, 32);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
        xButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        top += 17.0;
    }

    CGRect rect = contentView.frame;
    rect.origin.x = 0.0;
    rect.origin.y = top;
    contentView.frame = rect;
    top += rect.size.height + padding;
    selfSize = CGSizeMake(rect.size.width, top);
    [self addSubview:contentView];
    
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
}

- (void)dealloc
{
    
}

@end
