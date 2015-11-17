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

@interface EmoticonCell()
{
}
@property (nonatomic, retain)NSMutableArray *deleteButtons;
@end

@implementation EmoticonCell
@synthesize imaViewArray;
@synthesize delegate;

- (id)initWithImageCount:(NSInteger)count style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.deleteButtons = [[NSMutableArray alloc] init];
        float width = self.bounds.size.width;
        int nImageWidth = 95;
        imaViewArray = [[NSMutableArray alloc] init];
        self.labelArray = [[NSMutableArray alloc] init];
        
        float padding = (width - nImageWidth * count ) / (count + 1);
        CGRect rect = CGRectMake(padding, 8, nImageWidth, nImageWidth);
        for (int i=0; i<count; i++)
        {
            OLImageView *imageView = [[OLImageView alloc] init];
            [imageView setFrame:rect];
            imageView.tag = 1010+i;
            [self.contentView addSubview:imageView];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            rect.origin.x += padding + nImageWidth;
            imageView.userInteractionEnabled = YES;
            [imaViewArray addObject:imageView];
            imageView.hidden = YES;

            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:tapGesture];
            
            UILabel *label = [[UILabel alloc] init];
            [self.contentView addSubview:label];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            [self.labelArray addObject:label];
            label.hidden = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(imageView.bounds.size.width - 40, 0, 40, 30);
            [imageView addSubview:button];
            [button setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
            [self.deleteButtons addObject:button];
            button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [button addTarget:self action:@selector(deleteCachedEmoji:) forControlEvents:UIControlEventTouchUpInside];
            button.hidden = YES;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = [imaViewArray count];
    CGFloat padding = 10.0;
    CGFloat innerSpace = 8.0;

    int nImageWidth = (self.bounds.size.width - padding * 2 - (count - 1) * innerSpace) / count;
    CGRect rect = CGRectMake(padding, 8, nImageWidth, nImageWidth);
    for (int i=0; i<count; i++)
    {
        OLImageView *imageView = [imaViewArray objectAtIndex:i];
        imageView.frame = rect;
        
        UILabel *label = [self.labelArray objectAtIndex:i];
        CGRect rectLabel = rect;
        rectLabel.origin.y = CGRectGetMaxY(rect) + 8.0;
        rectLabel.size.height = 20;
        label.frame = rectLabel;
        
        rect.origin.x += innerSpace + nImageWidth;
    }
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    for (int i=0; i<[imaViewArray count]; i++)
    {
        OLImageView *imageView = [imaViewArray objectAtIndex:i];
        UIButton *button = [self.deleteButtons objectAtIndex:i];
        if (editMode)
        {
            button.hidden = (imageView.image != nil) ? NO : YES;
        }
        else
        {
            button.hidden = YES;
        }
    }
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

- (IBAction)deleteCachedEmoji:(id)sender
{
    NSInteger index = [self.deleteButtons indexOfObject:sender];
    UIImageView *imageView = [self.imaViewArray objectAtIndex:index];
    if ([delegate respondsToSelector:@selector(deleteImageAt:cell:)])
    {
        [delegate deleteImageAt:(imageView.tag - 1010) cell:self];
    }
}

- (void)setImages:(NSArray *)paths text:(NSArray *)textArray
{
    for (int i=0; i<[imaViewArray count]; i++)
    {
        OLImageView *imageView = [imaViewArray objectAtIndex:i];
        imageView.image = nil;
        imageView.hidden = YES;
        
        UILabel *label = [self.labelArray objectAtIndex:i];
        label.hidden = YES;
        
        UIButton *button = [self.deleteButtons objectAtIndex:i];
        button.hidden = YES;
    }
    
    for (int i=0; i<[paths count]; i++)
    {
        if ([imaViewArray count] > 0)
        {
            OLImageView *imageView = [imaViewArray objectAtIndex:i];
            NSString *path = [paths objectAtIndex:i];
            NSData *gifData = [NSData dataWithContentsOfFile:path];
            imageView.image = [OLImage imageWithData:gifData];
            imageView.hidden = NO;
            
            UIButton *button = [self.deleteButtons objectAtIndex:i];
            if (_editMode)
            {
                button.hidden = (gifData != nil) ? NO : YES;
            }
            else
            {
                button.hidden = YES;
            }
        }
    }
    
    for (int i=0; i<[textArray count]; i++)
    {
        if ([self.labelArray count] > i)
        {
            UILabel *label = [self.labelArray objectAtIndex:i];
            label.text = [textArray objectAtIndex:i];
            label.hidden = NO;
        }
    }
}

- (void)dealloc{

}

@end
