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
    __weak id<EmoticonCellDelegate>delegate;
}
@property (nonatomic, weak)id<EmoticonCellDelegate>delegate;
@property (nonatomic, retain)NSMutableArray *imaViewArray;
@property (nonatomic, retain)NSMutableArray *labelArray;
@property (nonatomic,assign) BOOL editMode;
- (void)setImages:(NSArray *)paths text:(NSArray *)textArray;

- (id)initWithImageCount:(NSInteger)count style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end


@protocol EmoticonCellDelegate <NSObject>

- (void)selectImage:(UIImage *)image at:(NSInteger)index cell:(UITableViewCell *)tableCell;
- (void)deleteImageAt:(NSInteger)index cell:(UITableViewCell *)tableCell;

@end