//
//  BubbleView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "BubbleView.h"
#import "MessageInputView.h"
#import "NSString+MessagesView.h"

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f

@interface BubbleView()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *deleteButtno;
@property (strong, nonatomic) UIImage *incomingBackground;
@property (strong, nonatomic) UIImage *outgoingBackground;

- (void)setup;

@end



@implementation BubbleView

@synthesize style;
@synthesize text, delegate;

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.incomingBackground = [UIImage imageNamed:@"bubbleSelected.png"];
    self.outgoingBackground = [[UIImage imageNamed:@"bubbleSelected.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:15];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleTap:)];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.image = self.outgoingBackground;
        [self addSubview:self.imageView];
        [self.imageView addGestureRecognizer:tapGesture];
        
        
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.font = [BubbleView font];
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        self.label.numberOfLines = 0;
        self.label.textColor = [UIColor blackColor];
        [self addSubview:self.label];
        
        self.deleteButtno = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButtno.frame = CGRectMake(self.imageView.bounds.size.width - 40, 0, 40, 30);
        [self.imageView addSubview:self.deleteButtno];
        [self.deleteButtno setImage:[UIImage imageNamed:@"close_button_white"] forState:UIControlStateNormal];
        self.deleteButtno.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.deleteButtno addTarget:self action:@selector(deleteCachedTextArt:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButtno.hidden = YES;
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    [delegate selectBubble:self];
}

#pragma mark - Setters
- (void)setStyle:(BubbleMessageStyle)newStyle
{
    style = newStyle;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)newText
{
    text = [newText copy];
    self.label.text = newText;
    [self setNeedsLayout];
}

- (void)setEditMode:(BOOL)editMode
{
    _editMode = editMode;
    self.deleteButtno.hidden = !_editMode;
}

- (IBAction)deleteCachedTextArt:(id)sender
{
    if ([delegate respondsToSelector:@selector(deleteTextAt:)])
    {
         [delegate deleteTextAt:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    CGSize bubbleSize = [BubbleView bubbleSizeForText:self.text];
    
    CGRect bubbleFrame = CGRectMake((self.frame.size.width - (int)bubbleSize.width) / 2,
                                    (frame.size.height - (int)bubbleSize.height) / 2,
                                    (int)bubbleSize.width,
                                    (int)bubbleSize.height);
    
    float widht = frame.size.width - 40;
    CGRect imageRect = CGRectMake((self.frame.size.width - widht) / 2,
                                  (frame.size.height - (int)bubbleSize.height) / 2,
                                  widht,
                                  (int)bubbleSize.height);
    imageRect.size.width = widht;
    self.imageView.frame = imageRect;
    
    
    CGSize textSize = [BubbleView textSizeForText:self.text];
    CGFloat textX = (CGFloat)self.outgoingBackground.leftCapWidth - 3.0f + ((self.style == BubbleMessageStyleOutgoing) ? bubbleFrame.origin.x : 0.0f);
    CGRect textFrame = CGRectMake(textX,
                                  kPaddingTop + bubbleFrame.origin.y,
                                  textSize.width,
                                  textSize.height);
    self.label.frame = textFrame;
}

#pragma mark - Bubble view
+ (UIFont *)font
{
    return [UIFont systemFontOfSize:16.0f];
}

+ (CGSize)textSizeForText:(NSString *)txt
{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width * 0.65f;
    int numRows = (txt.length / [BubbleView maxCharactersPerLine]) + 1;

    CGFloat height = MAX(numRows, [txt numberOfLines]) * [MessageInputView textViewLineHeight];
    
    return [txt sizeWithFont:[BubbleView font]
           constrainedToSize:CGSizeMake(width, height)
               lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)bubbleSizeForText:(NSString *)txt
{
	CGSize textSize = [BubbleView textSizeForText:txt];
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGFloat)cellHeightForText:(NSString *)txt
{
    return [BubbleView bubbleSizeForText:txt].height + kMarginTop + kMarginBottom;
}

+ (int)maxCharactersPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

@end