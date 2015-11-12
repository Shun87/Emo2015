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
    NSMutableDictionary *dictionary;
}
@property (nonatomic, copy)NSString *sourceFile;
@property (nonatomic, copy)NSString *demon;

- (id)initWithSource:(NSString *)fileName demon:(NSString *)demo;
- (NSString *)mapStrForNormal:(NSString *)normalStr;

@end

@interface CoolFontViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *fontlListArray;
    UITableView *mTableView;
    NSIndexPath *oldIndexPath;
}
@property (nonatomic, retain)NSMutableArray *fontlListArray;
@property (nonatomic, retain)IBOutlet UITableView *mTableView;
@property (nonatomic, retain)NSIndexPath *oldIndexPath;
@end
