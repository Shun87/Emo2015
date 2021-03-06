//
//  CoolFontViewController.h
//  Emoji keyboard
//
//  Created by chenshun on 14-4-22.
//  Copyright (c) 2014年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoolFont : NSObject
{
    NSMutableDictionary *mutableDictionary;
}
@property (nonatomic, copy)NSString *sourceFile;
@property (nonatomic, copy)NSString *demon;

- (id)initWithSource:(NSString *)fileName demon:(NSString *)demo;
- (NSString *)mapStrForNormal:(NSString *)normalStr;

@end

@interface CoolFontView : UIView
<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *fontlListArray;
    UITableView *mTableView;
    NSIndexPath *oldIndexPath;
}
@property (nonatomic, retain)CoolFont *curFont;
@property (nonatomic, retain)NSMutableArray *fontlListArray;
@property (nonatomic, retain) UITableView *mTableView;
@property (nonatomic, retain)NSIndexPath *oldIndexPath;
@end
