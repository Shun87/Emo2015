//
//  ArtViewController.h
//  CustomEmoji
//
//  Created by chenshun on 13-7-6.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleView.h"
#import "TTSocial.h"

@interface ArtViewController : UIViewController<BubbleViewDelete, UIActionSheetDelegate, UITableViewDataSource,
UITableViewDelegate, UIAlertViewDelegate>
{
    UIScrollView *scrollView;
    NSString *title;
    NSString *aText;
    NSInteger showIndex;
    TTSocial *social;
    IBOutlet UITableView *mTableView;
    NSMutableArray *textArray;
}
@property (nonatomic, copy)NSString *aText;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger showIndex;
@property BOOL editMode;
@end
