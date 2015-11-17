//
//  CustomSegmentCtrol.m
//  Emoji keyboard
//
//  Created by tsinglink on 15/11/13.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import "CustomSegmentCtrol.h"
#import "PureLayout.h"

@interface CustomSegmentCtrol()
@property (nonatomic, strong)UIButton *selectButton;
@property (nonatomic, retain)NSMutableArray *normalImges;
@property (nonatomic, retain)NSMutableArray *selectedImges;
@property (nonatomic, retain)NSMutableArray *buttons;
@end
@implementation CustomSegmentCtrol

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.buttons = [[NSMutableArray alloc] init];
        self.normalImges = [[NSMutableArray alloc] init];
        self.selectedImges = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)reloadImages:(NSArray *)images selImages:(NSArray *)selImages
{
    [self.normalImges addObjectsFromArray:images];
    [self.selectedImges addObjectsFromArray:selImages];
    [self.buttons removeAllObjects];
    for (int i=0; i<[images count]; i++)
    {
        NSString *imageName = [images objectAtIndex:i];
        UIButton *button = [self addButton:nil sel:@selector(selectAction:) image:[UIImage imageNamed:imageName] backgroundImage:[UIImage imageNamed:@"emoji_button_sel"]];
        [self.buttons addObject:button];
    }
    [self layoutButton];
}

- (void)reloadTitles:(NSArray *)titles
{
    [self.buttons removeAllObjects];
    for (int i=0; i<[titles count]; i++)
    {
        NSString *text = [titles objectAtIndex:i];
        UIButton *button = [self addButton:text sel:@selector(selectAction:) image:nil backgroundImage:[UIImage imageNamed:@"emoji_button_sel"]];
        [self.buttons addObject:button];
    }
    [self layoutButton];
}

- (void)layoutButton
{
    [self.buttons autoSetViewsDimension:ALDimensionWidth toSize:30];
    UIButton *preButton;
    for (int i=0; i<[self.buttons count]; i++)
    {
        UIButton *button = [self.buttons objectAtIndex:i];
        [button autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        if (preButton)
        {
            [button autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:preButton];
        }
        
        preButton = button;
    }
    [[self.buttons firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:5.0];
    [[self.buttons lastObject] autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5.0];
    [self changeButtonImage:[self.buttons firstObject]];
}

- (UIButton *)addButton:(NSString *)title sel:(SEL)sel image:(UIImage *)image backgroundImage:(UIImage *)bgImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    [button setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (IBAction)selectAction:(id)sender
{
    [self changeButtonImage:sender];
    if ([self.delegate respondsToSelector:@selector(segmentCtrl:didSelectAtIndex:)])
    {
        NSInteger index = [self.buttons indexOfObject:sender];
        [self.delegate segmentCtrl:self didSelectAtIndex:index];
    }
}

- (void)scrollToIndex:(NSInteger)index
{
    NSInteger curIndex = [self.buttons indexOfObject:self.selectButton];
    if (index < [self.buttons count] && index != curIndex)
    {
        [self changeButtonImage:[self.buttons objectAtIndex:index]];
    }
}

- (void)changeButtonImage:(UIButton *)button
{
    if (self.selectButton != nil && self.selectButton != button)
    {
        [self.selectButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        if ([self.normalImges count] > 0)
        {
            NSInteger index = [self.buttons indexOfObject:self.selectButton];
            NSString *imageName = [self.normalImges objectAtIndex:index];
            [self.selectButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
    }
    
    self.selectButton = button;
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"emoji_button_sel"] forState:UIControlStateNormal];
    
    if ([self.selectedImges count] > 0)
    {
        NSInteger index = [self.buttons indexOfObject:self.selectButton];
        NSString *imageName = [self.selectedImges objectAtIndex:index];
        [self.selectButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }

}

@end
