//
//  SymbolView.m
//  FontDesigner
//
//  Created by  on 13-6-17.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "SymbolView.h"
#import "SymbolDesc.h"
#import "UIColor+HexColor.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SymbolUnits.h"
#import <QuartzCore/QuartzCore.h>
#import "LablesView.h"
#import "PureLayout.h"

#define kLabelBaseTag   1000

@implementation UIScrollView(Overide)
// called before scrolling begins if touches have already been delivered to a subview of the scroll view. if it returns NO the touches will continue to be delivered to the subview and scrolling will not occur
// not called if canCancelContentTouches is NO. default returns YES if view isn't a UIControl
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

@end

@interface SymbolView() <CustomSegmentCtrolDelegate>
{
    NSInteger rowCount;
    NSInteger labelSize;
}
@end

@implementation SymbolView
@synthesize delegate = _delegate;

- (void)dealloc
{

}

- (id)initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        dataSource = [[NSMutableArray alloc] init];
        symbolList = [[NSMutableArray alloc] init];
        labelArray = [[NSMutableArray alloc] init];
        rowCount = [SymbolView getRowCount];
        labelSize = [SymbolView getLabelSize];
        
        horiTableView = [[HorizontalTableView alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, labelSize * rowCount)];
        horiTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        horiTableView.horizontalDataSource = self;
        horiTableView.rowWidth = labelSize;
        horiTableView.delegate = self;
        [self addSubview:horiTableView];
    }
    return self;
}

- (void)setSymbolShowType:(SymbolType)aType
{
    type = aType;
    [self addSegment];
    [self loadLocalSymbols];
    [horiTableView reloadData];
}

- (void)clean
{
    [horiTableView removeFromSuperview];
    horiTableView = nil;
}

- (void)addSegment
{
    segment = [CustomSegmentCtrol newAutoLayoutView];
    [self addSubview:segment];
    [segment autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [segment autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
    [segment autoSetDimension:ALDimensionHeight toSize:30.0];
    if (type == ST_Symbol)
    {
        [segment reloadTitles:[NSArray arrayWithObjects:
                               @"❀",
                               @"☠",
                               @"Ⓐ",
                               @"≑",
                               @"◪",
                               nil ]];

    }
    else
    {
        [segment reloadImages:@[@"emoji_toolbar_button_1", @"emoji_toolbar_button_2", @"emoji_toolbar_button_3" , @"emoji_toolbar_button_4" , @"emoji_toolbar_button_5"] selImages:@[@"emoji_toolbar_button_sel1", @"emoji_toolbar_button_sel2", @"emoji_toolbar_button_sel3" , @"emoji_toolbar_button_sel4" , @"emoji_toolbar_button_sel5"]];
    }

    segment.delegate = self;

    UIButton *button1 = [self addButton:nil sel:@selector(deleteBackwardString:) image:[UIImage imageNamed:@"delete_button"] highImage:[UIImage imageNamed:@"delete_buttont_sel"]];
    
    UIButton *button3 = [self addButton:nil sel:@selector(insertReturn:) image:[UIImage imageNamed:@"button_keyboard_enter"] highImage:nil];
    NSArray *rightButtons = @[button1, button3];
    [rightButtons autoSetViewsDimension:ALDimensionWidth toSize:40];
    [rightButtons autoSetViewsDimension:ALDimensionHeight toSize:30.0];
    [button1 autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0];
    UIButton *preButton2;
    for (int i=0; i<[rightButtons count]; i++)
    {
        UIButton *button = [rightButtons objectAtIndex:i];
        if (preButton2)
        {
            [button autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:preButton2];
        }
        
        preButton2 = button;
    }
    [rightButtons autoAlignViewsToEdge:ALEdgeBottom];
    [button1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];

    UIButton *spaceButton = [self addButton:@"Space" sel:@selector(insertSpace:) image:nil highImage:nil];
    [spaceButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0];
    [segment autoSetDimension:ALDimensionHeight toSize:30.0];
    [spaceButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
    spaceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [spaceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [spaceButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
}

- (IBAction)changeSymbolCategory:(id)sender
{
    NSInteger index = segmentControl.selectedSegmentIndex;
}

- (void)segmentCtrl:(CustomSegmentCtrol *)segment didSelectAtIndex:(NSInteger)section
{
    [horiTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(HorizontalTableView *)tableView
{
    return [dataSource count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(HorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SymbolUnits *unit = [dataSource objectAtIndex:section];
    int count = [unit.symbolArray count];
    return  count / rowCount + (count % rowCount == 0 ? 0 : 1);
}

- (void)tableView:(HorizontalTableView *)tableView initializeView:(UIView *)contentView atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat top = 0;
    for (int i=0; i<rowCount; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, top, labelSize, labelSize);
        [contentView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor clearColor];
        
        if (type == ST_Symbol)
        {
            label.font = [UIFont systemFontOfSize:30];
        }
        else
        {
            label.font = [UIFont fontWithName:@"Apple Color Emoji" size:32];
        }
        
        top += labelSize;
        label.tag = kLabelBaseTag + i;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [label addGestureRecognizer:tapGesture];
    }
}

- (void)tableView:(HorizontalTableView *)tableView updateView:(UIView *)contentView atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    SymbolUnits *unit = [dataSource objectAtIndex:section];
    
    NSRange range;
    range.location = rowCount * row;
    range.length = rowCount;
    if (range.location + range.length > [unit.symbolArray count])
    {
        range.length = [unit.symbolArray count] - range.location;
    }
    
    for (int i=0; i<rowCount; i++)
    {
        UILabel *label = [contentView viewWithTag:kLabelBaseTag + i];
        label.text = nil;
    }
    
    NSArray *subArray = [unit.symbolArray subarrayWithRange:range];
    for (int i=0; i<[subArray count]; i++)
    {
        UILabel *label = [contentView viewWithTag:kLabelBaseTag + i];
        NSString *emoji = [subArray objectAtIndex:i];
        label.text = emoji;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect visibleBounds = scrollView.bounds;
    NSIndexPath *indexPath = [horiTableView indexPathForRowAtPoint:visibleBounds.origin];
    [segment scrollToIndex:[indexPath section]];
}

- (IBAction)deleteBackwardString:(id)sender
{
    AudioServicesPlaySystemSound(1104);
    [_delegate performSelector:@selector(deleteBackwardString:) withObject:nil];
}

- (IBAction)artText:(id)sender
{
    AudioServicesPlaySystemSound(1104);
    [_delegate performSelector:@selector(artText:) withObject:nil];
}

- (IBAction)insertSpace:(id)sender
{
    AudioServicesPlaySystemSound(1104);
    [_delegate performSelector:@selector(insertSpace:) withObject:nil];
}

- (IBAction)insertReturn:(id)sender
{
    AudioServicesPlaySystemSound(1104);
     [_delegate performSelector:@selector(insertReturn:) withObject:nil];
}

- (void)removeAllSymbol
{
    for (int i=0; i<[labelArray count]; i++)
    {
        UIView *subView = (UIView *)[labelArray objectAtIndex:i];
        [subView removeFromSuperview];
    }
    
    [labelArray removeAllObjects];
}

- (IBAction)selectEmoji:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *text = [button titleForState:UIControlStateNormal];
    if ([text length] == 0 || text == nil)
    {
        return;
    }
    AudioServicesPlaySystemSound(1104);
    
    NSLog(@"%@", text);
    NSData *data = [text dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
    int nLen = [data length];
    UTF32Char hexValue = 0;
    // for (int i=0; i<nLen; i+=2)
    {
        if (nLen == 2)
        {
            NSRange range;
            range.location = 0;
            range.length = 2;
            char buffer[2];
            [data getBytes:buffer range:range];
            hexValue = *(ushort *)buffer;
        }
        else if (nLen == 4)
        {
            NSRange range;
            range.location = 0;
            range.length = 2;
            char buffer[2];
            [data getBytes:buffer range:range];
            unichar high = *(ushort *)buffer;
            
            range.location = 2;
            range.length = 2;
            char buffer2[2];
            [data getBytes:buffer2 range:range];
            unichar low = *(ushort *)buffer2;
            hexValue = CFStringGetLongCharacterForSurrogatePair(high, low);
        }
    }
    
    [_delegate selectSymbol:text];
    
    [self saveHistory:hexValue];
}

- (void)handleTap:(UIGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    if (label.text == nil || [label.text length] == 0)
    {
        return;
    }
    
    AudioServicesPlaySystemSound(1104);

   [_delegate selectSymbol:label.text];
}

- (void)saveHistory:(unsigned int)hexValue
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"History.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    if (array == nil)
    {
        array = [NSMutableArray array];
    }
    
    NSNumber *number = [NSNumber numberWithUnsignedInt:hexValue];
    NSLog(@"%d", [number intValue]);
    if (![array containsObject:number] )
    {
        [array insertObject:number atIndex:0];
        [array writeToFile:path atomically:YES];
    }
}

- (void)loadLocalSymbols
{
    if (type == ST_Symbol)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CommonSymbol.plist" ofType:nil];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        for (int i=0; i<[[dic allKeys] count]; i++)
        {
            NSString *key = [[dic allKeys] objectAtIndex:i];
            NSDictionary *arrayDic = [dic objectForKey:key];
            
            SymbolUnits *units = [[SymbolUnits alloc] init];
            units.symbolID = [[arrayDic objectForKey:@"symboID"] intValue];
            for (int j=0; j<[[arrayDic allKeys] count] - 1; j++)
            {
                NSString *key2 = [NSString stringWithFormat:@"h%d", j+1];//[[arrayDic allKeys] objectAtIndex:j];
                
                if (![key2 isEqualToString:@"symboID"])
                {
                    NSDictionary *dic2 = [arrayDic objectForKey:key2];
                    NSString *min = [dic2 objectForKey:@"from"];
                    NSString *max = [dic2 objectForKey:@"to"];
                    
                    
                    NSString *minUnicode = [min stringByReplacingOccurrencesOfString:@"U+" withString:@""];
                    NSString *maxUnicode = [max stringByReplacingOccurrencesOfString:@"U+" withString:@""];
                    unichar minHex = (unichar)strtol([minUnicode UTF8String], 0, 16);
                    unichar maxHex = (unichar)strtol([maxUnicode UTF8String], 0, 16);
                    for (unichar hex = minHex; hex <= maxHex; hex++)
                    {
                        BOOL legal = ![[NSCharacterSet illegalCharacterSet] characterIsMember:hex];
                        if (legal)
                        {
                            NSData *data = [NSData dataWithBytes:&hex length:sizeof(ushort)];
                            NSString *symbolStr = [[NSString alloc] initWithData:data
                                                                        encoding:NSUTF16LittleEndianStringEncoding];
                            
                            [units.symbolArray addObject:symbolStr];
                        }
                    }
                }
            }
            [dataSource addObject:units];
        }
        
        [dataSource sortUsingComparator: ^NSComparisonResult(id obj1, id obj2){
            
            SymbolUnits *objSymbol1 = (SymbolUnits *)obj1;
            SymbolUnits *objSymbol2 = (SymbolUnits *)obj2;
            
            if (objSymbol1.symbolID > objSymbol2.symbolID)
            {
                return NSOrderedDescending;
            }
            
            return NSOrderedAscending;
        }];
    }
    else
    {
        NSString *path;
        CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
        if (version >= 9.1)
        {
            path = [[NSBundle mainBundle] pathForResource:@"emoji_unicode.plist" ofType:nil];
        }
        else if (version >= 8.3 && version < 9.1)
        {
            path = [[NSBundle mainBundle] pathForResource:@"emoji83.plist" ofType:nil];
        }
        else if (version < 8.3)
        {
            path = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSArray *array = @[@"People", @"Nature", @"Objects", @"Places", @"Symbols"];
        for (int i=0; i<[array count]; i++)
        {
            SymbolUnits *units = [[SymbolUnits alloc] init];
            NSString *key = [array objectAtIndex:i];
            NSArray *emojis = [dic objectForKey:key];
            [units.symbolArray addObjectsFromArray:emojis];
            [dataSource addObject:units];
        }
    }
}

//- (UIView *)tableView:(HorizontalTableView *)tableView viewForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIView *m = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, tableView.bounds.size.height)];
//    NSInteger section = [indexPath section];
//    NSInteger row = [indexPath row];
//    SymbolUnits *unit = [dataSource objectAtIndex:section];
//
//    NSRange range;
//    range.location = rowCount * row;
//    range.length = rowCount;
//    if (range.location + range.length > [unit.symbolArray count])
//    {
//        range.length = [unit.symbolArray count] - range.location;
//    }
//
//    CGFloat top = 0;
//    NSArray *subArray = [unit.symbolArray subarrayWithRange:range];
//    for (int i=0; i<[subArray count]; i++)
//    {
//        NSString *emoji = [subArray objectAtIndex:i];
//
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, top, 40, 40)];
//        [m addSubview:label];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor blackColor];
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont systemFontOfSize:30];
//        top += 40;
//        label.tag = kLabelBaseTag + i;
//        label.text = emoji;
//    }
//    return m;
//}
- (UIButton *)addButton:(NSString *)title sel:(SEL)sel image:(UIImage *)image highImage:(UIImage *)highImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    //    [button setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_active"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (NSInteger)getLabelSize
{
    return 41.0;
}

+ (NSInteger)getRowCount
{
    NSInteger row = 4;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.bounds.size.height >= 667)
    {
        row = 5;
    }
    return row;
}

+ (NSInteger)calculateHeight
{
    NSInteger bottom = 50;
    NSInteger count = [SymbolView getRowCount];
    return [SymbolView getLabelSize] * count + bottom;
}


@end
