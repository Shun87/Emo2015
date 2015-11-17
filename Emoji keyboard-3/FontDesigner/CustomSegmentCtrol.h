//
//  CustomSegmentCtrol.h
//  Emoji keyboard
//
//  Created by tsinglink on 15/11/13.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegmentCtrolDelegate;
@interface CustomSegmentCtrol : UIView

@property (nonatomic, weak)id <CustomSegmentCtrolDelegate> delegate;

- (void)reloadTitles:(NSArray *)titles;
- (void)scrollToIndex:(NSInteger)index;
- (void)reloadImages:(NSArray *)images selImages:(NSArray *)selImages;
@end

@protocol CustomSegmentCtrolDelegate <NSObject>
- (void)segmentCtrl:(CustomSegmentCtrol *)segment didSelectAtIndex:(NSInteger)section;
@end
