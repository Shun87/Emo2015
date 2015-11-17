//
//  SymbolListViewController.h
//  FontDesigner
//
//  Created by chenshun on 13-5-23.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SymbolListViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *symbolListArray;
    UITableView *mTableView;
    NSIndexPath *oldIndexPath;
}
@property (nonatomic, retain)NSIndexPath *oldIndexPath;

@property (nonatomic, retain)NSMutableArray *symbolListArray;
@property (nonatomic, retain)IBOutlet UITableView *mTableView;
@end
