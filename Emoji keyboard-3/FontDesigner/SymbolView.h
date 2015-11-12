//
//  SymbolView.h
//  FontDesigner
//
//  Created by  on 13-6-17.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SymbolUnits.h"
typedef enum 
{
    ST_Symbol,
    ST_Emoji,
    ST_History,
    ST_Custom
}SymbolType;
@protocol SymbolViewDelegate;
@interface SymbolView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UISegmentedControl *segmentControl;
    UIScrollView *scrollViewButtons;
    NSMutableArray *symbolList;
    NSMutableArray *labelArray;
    __weak id<SymbolViewDelegate> _delegate;
    SymbolType type;
    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    NSMutableArray *dataSource;
    int countOnePage;
    int currentIndex;
    
}

@property (nonatomic, weak)id<SymbolViewDelegate> delegate;

- (void)setSymbolShowType:(SymbolType)aType;
- (void)showSymbols:(SymbolUnits *)units;
@end
@protocol SymbolViewDelegate <NSObject>

- (void)selectSymbol:(NSString *)text;
@end