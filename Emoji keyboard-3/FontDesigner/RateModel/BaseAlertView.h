//
//  DeviceConnectViewController.h
//  iMyCamera
//
//  Created by chenshun on 14-2-17.
//  Copyright (c) 2014年 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAlertWidth 280.0f
#define kAlertHeight 320.0f

@interface BaseAlertView : UIView
{
    CGSize selfSize;
}
- (void)show;
@property (nonatomic, copy) dispatch_block_t cancelBlock;
@property (nonatomic, copy) dispatch_block_t okBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, assign) CGSize selfSize;

- (void)dismissAlert:(dispatch_block_t)block;
- (id)initWithSize:(CGSize)size;

- (void)showCloseButton;
- (void)setContentView:(UIView *)contentView;
@end
