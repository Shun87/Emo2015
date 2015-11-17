//
//  EmoticonCell.m
//  Characters
//
//  Created by chenshun on 13-7-8.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "EmoticonCell.h"

@implementation EmoticonCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!imaViewArray)
        {
            imaViewArray = [[NSMutableArray alloc] init];
        }
        
        float left = (self.frame.size.width - 180 ) / 4;
        CGRect rect = CGRectMake(left, 8, 60, 60);
        for (int i=0; i<3; i++)
        {
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
            [self.contentView addSubview:imageView];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            rect.origin.x += left + 60;
            imageView.userInteractionEnabled = YES;
            [imaViewArray addObject:imageView];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
            [imageView addGestureRecognizer:tapGesture];
            
        }
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    [delegate selectImage:imageView.image cell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImages:(NSArray *)imgArray
{
    for (int i=0; i<[imaViewArray count]; i++)
    {
        UIImageView *view = [imaViewArray objectAtIndex:i];
        NSString *imageName2 = [imgArray objectAtIndex:i];
        
        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource: imageName2 ofType:nil];
        UIImage *backgroundImage = [UIImage imageWithContentsOfFile:backgroundImagePath];
        view.image = backgroundImage;
    }
}

- (void)dealloc{
    [imaViewArray release];
    [super dealloc];
}

@end
