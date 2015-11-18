//
//  CoolFontViewController.m
//  Emoji keyboard
//
//  Created by chenshun on 14-4-22.
//  Copyright (c) 2014年 ChenShun. All rights reserved.
//

#import "CoolFontView.h"

@implementation CoolFont
@synthesize sourceFile, demon;

- (id)initWithSource:(NSString *)fileName demon:(NSString *)demo
{
    if (self = [super init])
    {
        dictionary = [[NSMutableDictionary alloc] init];
        self.sourceFile = fileName;
        self.demon = demo;
    }
    return self;
}

- (void)loadMapStr
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.sourceFile ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [content componentsSeparatedByString:@"\n"];
    for (int i=0; i<[array count]; i++)
    {
        NSString *subStr = [array objectAtIndex:i];
        NSArray *subArray = [subStr componentsSeparatedByString:@"-"];
        if ([subArray count] == 2)
        {
            [dictionary setValue:[subArray objectAtIndex:1] forKey:[subArray objectAtIndex:0]];
        }
    }
}

- (NSString *)mapStrForNormal:(NSString *)normalStr
{
    if ([dictionary count] == 0)
    {
        [self loadMapStr];
    }
    return [dictionary valueForKey:normalStr];
}

- (void)dealloc
{

}

@end

@interface CoolFontView ()

@end

@implementation CoolFontView
@synthesize fontlListArray, mTableView, oldIndexPath;
- (void)dealloc
{

}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initSubView];
    }
    
    return self;
}

- (void)initSubView
{
    mTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:mTableView];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mTableView.rowHeight = 36;
    fontlListArray = [[NSMutableArray alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"alphabets_settings.plist" ofType:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *subDic = [dic valueForKey:@"alphabeths"];
    for (int i=0; i<[[subDic allKeys] count]; i++)
    {
        NSString *key = [[subDic allKeys] objectAtIndex:i];
        NSDictionary *fontDic = [subDic valueForKey:key];
        
        NSString *source = [fontDic valueForKey:@"source_file"];
        NSString *demo = [fontDic valueForKey:@"text_example"];
        CoolFont *font = [[CoolFont alloc] initWithSource:source demon:demo];
        [fontlListArray addObject:font];

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fontlListArray count];
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
    CoolFont *font = [fontlListArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = font.demon;
    if (self.curFont == font)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.oldIndexPath = indexPath;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.oldIndexPath];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (oldIndexPath.row != [indexPath row])
    {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.oldIndexPath = indexPath;
    }

    CoolFont *font = [fontlListArray objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFontKeyboard" object:font];
}

@end
