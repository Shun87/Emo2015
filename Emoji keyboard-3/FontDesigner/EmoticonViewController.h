//
//  EmoticonViewController.h
//  Characters
//
//  Created by chenshun on 13-7-8.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmoticonCell.h"
#import "TTSocial.h"

@interface EmoticonViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate, EmoticonCellDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *mTableView;
    NSMutableArray *array;
    TTSocial *social;
    UIImage *image;
    NSString *emtionTitle;
    
    NSInteger selectIndex;
}
@property NSInteger selectIndex;
@property (nonatomic, retain)UIImage *image;
@property (nonatomic, copy)NSString *emtionTitle;
@property (nonatomic, weak)UIViewController *viewController;
@property (nonatomic, assign)BOOL localFavorite;
@property BOOL animated;
- (void)loadAd;
- (void)startEding:(BOOL)edit;
- (void)localEmoji;
@end
