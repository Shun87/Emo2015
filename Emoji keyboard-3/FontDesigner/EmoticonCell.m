//
//  EmoticonCell.m
//  Characters
//
//  Created by chenshun on 13-7-8.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "EmoticonCell.h"

#import "OLImage.h"
#import "OLImageView.h"
#include <QuartzCore/QuartzCore.h>

@implementation EmoticonCell
@synthesize imaViewArray;
@synthesize delegate;

- (id)initWithImageCount:(NSInteger)count style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        float width = self.bounds.size.width;
        NSString *model = [UIDevice currentDevice].model;
        if ([model hasPrefix:@"iPad"] || [model hasSuffix:@"iPad"])
        {
            width = 768;
        }
        int nImageWidth = 95;
        imaViewArray = [[NSMutableArray alloc] init];
        backgroudViewArray = [[NSMutableArray alloc] init];
        float left = (width - nImageWidth * count ) / (count + 1);
        CGRect rect = CGRectMake(left, 8, nImageWidth, nImageWidth);
        for (int i=0; i<count; i++)
        {
            OLImageView *imageView = [[OLImageView alloc] init];
            [imageView setFrame:rect];
            imageView.tag = 1010+i;
            [self.contentView addSubview:imageView];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            rect.origin.x += left + nImageWidth;
            imageView.userInteractionEnabled = YES;
            [imaViewArray addObject:imageView];
            imageView.hidden = YES;

            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:tapGesture];
            
            UIView *view = [[UIView alloc] initWithFrame:imageView.frame];
            [self.contentView insertSubview:view belowSubview:imageView];
            view.backgroundColor = [UIColor whiteColor];
            view.hidden = YES;
            [backgroudViewArray addObject:view];
        }
    }
    return self;
}


- (void)handleTap:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    [delegate selectImage:imageView.image at:(imageView.tag - 1010) cell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImages:(NSArray *)paths
{
    for (int i=0; i<[imaViewArray count]; i++)
    {
        OLImageView *imageView = [imaViewArray objectAtIndex:i];
        UIView *backView = [backgroudViewArray objectAtIndex:i];
        imageView.hidden = YES;
        backView.hidden = YES;
    }
    
    for (int i=0; i<[paths count]; i++)
    {
        if ([imaViewArray count] > 0)
        {
            OLImageView *imageView = [imaViewArray objectAtIndex:i];
            UIView *backView = [backgroudViewArray objectAtIndex:i];
            backView.hidden = NO;
            NSString *path = [paths objectAtIndex:i];

            NSData *gifData = [NSData dataWithContentsOfFile:path];
            
            imageView.image = [OLImage imageWithData:gifData];
            imageView.hidden = NO;
        }
    }
}

- (void)dealloc{

}

@end
