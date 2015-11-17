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
@property (nonatomic, retain)NSArray *mTitles;
@property (nonatomic, retain)NSMutableArray *buttons;
@end
@implementation CustomSegmentCtrol

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.buttons = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)reloadTitles:(NSArray *)titles
{
    self.mTitles = titles;
    [self.buttons removeAllObjects];
    for (int i=0; i<[self.mTitles count]; i++)
    {
        NSString *text = [self.mTitles objectAtIndex:i];
        UIButton *button = [self addButton:text sel:@selector(selectAction:) image:nil];
        [self.buttons addObject:button];
    }
    UIButton *button1 = [self addButton:nil sel:@selector(selectAction:) image:[UIImage imageNamed:@"button_keyboard_space"]];
    [self.buttons addObject:button1];
    UIButton *button2 = [self addButton:nil sel:@selector(selectAction:) image:[UIImage imageNamed:@"button_keyboard_delete"]];
    [self.buttons addObject:button2];
    UIButton *button3 = [self addButton:nil sel:@selector(selectAction:) image:[UIImage imageNamed:@"button_keyboard_enter"]];
    [self.buttons addObject:button3];
    
    [self.buttons autoMatchViewsDimension:ALDimensionHeight];
    [[self.buttons firstObject] autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
    [[self.buttons firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.buttons autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0.0 insetSpacing:YES matchedSizes:YES];
}

- (UIButton *)addButton:(NSString *)title sel:(SEL)sel image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    [button setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_active"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_select"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}

@end
