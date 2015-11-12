//
//  ArtEmojiViewController.h
//  CustomEmoji
//
//  Created by chenshun on 13-7-6.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtEmojiViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *aTableView;
    NSMutableArray *array;
    IBOutlet UIBarButtonItem *upgradeButton;
}
@property BOOL showPromtAd;
@property BOOL editMode;
- (void)showArt:(NSInteger)index;
@end
