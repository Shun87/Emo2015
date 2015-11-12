//
//  SymbolListViewController.m
//  FontDesigner
//
//  Created by chenshun on 13-5-23.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "SymbolListViewController.h"
#import "UIColor+HexColor.h"
#import "SymbolDesc.h"
#import "NSString+Transform.h"
#import "SymbolsViewController.h"
#import "AppDelegate.h"
#import "SymbolUnits.h"

@interface SymbolListViewController ()

@end

@implementation SymbolListViewController

@synthesize symbolListArray, mTableView, oldIndexPath;
- (void)dealloc
{

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        symbolListArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHex:LightGray];
    self.mTableView.backgroundView = nil;
    self.mTableView.separatorColor = [UIColor colorFromHex:SeperatorColor];
//
    
    UIBarButtonItem *emojiButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Font", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(showFonts:)];
    
    self.navigationItem.rightBarButtonItem = emojiButton;

    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UnicodeMap.plist" ofType:nil];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithContentsOfFile:path];
    for (int i=0; i<[mutableArray count]; i++)
    {
        NSDictionary *dic = [mutableArray objectAtIndex:i];
        NSString *name = [dic objectForKey:@"Category"];
        
        NSString *unicode = [dic objectForKey:@"Character"];
        SymbolUnits *symbolUnit = [[SymbolUnits alloc] init];
        symbolUnit.name = name;
        
        symbolUnit.unicodeVal = unicode;
        NSString *unicodeRange = [dic objectForKey:@"SubRange"];
        if (unicodeRange == nil)
        {
            unicodeRange = [dic objectForKey:@"Range"];
        }
        NSArray *rangeArray = [unicodeRange componentsSeparatedByString:@","];
        for (int j=0; j<[rangeArray count]; j++)
        {
            NSString *oneRange = [rangeArray objectAtIndex:j];
            NSArray *valueArray = [oneRange componentsSeparatedByString:@"~"];
            if ([valueArray count] == 2)
            {
                NSString *min = [valueArray objectAtIndex:0];
                NSString *max = [valueArray objectAtIndex:1];
                SymbolDesc *symbolDesc = [[SymbolDesc alloc] initWithName:name minHex:min maxHex:max];
                [symbolUnit.symbolArray addObject:symbolDesc];

            }
        }

        [symbolListArray addObject:symbolUnit];

    }
    
    [symbolListArray sortUsingComparator: ^NSComparisonResult(id obj1, id obj2){
        
        SymbolUnits *objStr1 = (SymbolUnits *)obj1;
        SymbolUnits *objStr2 = (SymbolUnits *)obj2;
        return [objStr1.name compare:objStr2.name];
    }];
}

- (IBAction)showFonts:(id)sender
{
    [self.tabBarController.view removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (IBAction)emojSymbols:(id)sender
{
    SymbolsViewController *detailViewController = [[SymbolsViewController alloc] initWithNibName:@"SymbolsViewController" bundle:nil];
    detailViewController.unicodeType = Emoji;
    [self.navigationController pushViewController:detailViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [symbolListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (oldIndexPath == nil)
    {
        if ([indexPath row] == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.oldIndexPath = indexPath;
        }
    }
    else if ([oldIndexPath row] == [indexPath row])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.oldIndexPath = indexPath;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    if ([symbolListArray count] > [indexPath row])
    {
        SymbolUnits *units = [symbolListArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = units.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.oldIndexPath];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (oldIndexPath.row != [indexPath row])
    {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.oldIndexPath = indexPath;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSymbols" object:[symbolListArray objectAtIndex:[indexPath row]]];
}
@end
