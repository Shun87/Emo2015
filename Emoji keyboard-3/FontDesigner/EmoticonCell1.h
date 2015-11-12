//
//  EmoticonCell.h
//  Characters
//
//  Created by chenshun on 13-7-8.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmoticonCellDelegate;
@interface EmoticonCell : UITableViewCell
{
    NSMutableArray *imaViewArray;
    id<EmoticonCellDelegate>delegate;
}
@property (nonatomic, assign)id<EmoticonCellDelegate>delegate;
- (void)setImages:(NSArray *)imgArray;

@end


@protocol EmoticonCellDelegate <NSObject>

- (void)selectImage:(UIImage *)image cell:(UITableViewCell *)tableCell;

@end