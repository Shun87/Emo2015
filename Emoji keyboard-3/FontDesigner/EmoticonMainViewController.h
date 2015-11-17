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

@interface EmoticonMainViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate, EmoticonCellDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *mTableView;
    IBOutlet UIBarButtonItem *helpButton;
    IBOutlet UIBarButtonItem *upgradeButton;
    NSMutableArray *array;
    NSMutableArray *imageArray;
    TTSocial *social;
    UIImage *image;
    UISegmentedControl *segment;
    NSInteger countPerRow;
}
@property (nonatomic, retain)UIImage *image;

- (IBAction)helpAction:(id)sender;
- (IBAction)upgradeAction:(id)sender;
@end
