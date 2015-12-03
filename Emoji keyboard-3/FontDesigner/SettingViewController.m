//
//  MoreViewController.m
//  Text2Group
//
//  Created by chenshun on 13-4-12.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "SettingViewController.h"
#import "TTSocial.h"
#import "UIColor+HexColor.h"
#import "MoreApp.h"


#import "AppDelegate.h"
#import "InAppRageIAPHelper.h"

@interface SettingViewController ()
{
    TTSocial *socila;
    InAppRageIAPHelper *iapHelper;
}
@end

@implementation SettingViewController
@synthesize appArray;

- (void)dealloc
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = NSLocalizedString(@"Settings", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"Settings.png"];
        socila = [[TTSocial alloc] init];
        socila.viewController = self;
        iapHelper = [[InAppRageIAPHelper alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    self.appArray = [MoreApp moreApps];
}

- (void)productsLoaded:(NSNotification *)notification
{
    NSLog(@"productsLoaded");
}

- (void)productPurchased:(NSNotification *)notification
{
    NSString *productIdentifier = (NSString *)[notification object];
    NSLog(@"provideContent Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)productPurchaseFailed:(NSNotification *)notification
{
    NSLog(@"productPurchaseFailed");
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)creatCellWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"parameter"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 230, cell.bounds.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.tag = 100;
    [cell.contentView addSubview:label];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
#if FreeApp
    if ([indexPath section] == 2)
#else
    if ([indexPath section] == 0)
#endif
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, (cell.bounds.size.height - 36 ) / 2, 36, 36)];
        imageView.tag = 101;
        [cell.contentView addSubview:imageView];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        imageView.layer.cornerRadius = 6;
        imageView.clipsToBounds = YES;
    }
    
    CGRect rect = cell.frame;
    rect.origin.x = cell.contentView.frame.size.width - 40;
    rect.size.width = 40;
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:rect];
    label3.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    label3.backgroundColor = [UIColor clearColor];
    label3.tag = 104;
    [cell.contentView addSubview:label3];
    label3.font = [UIFont systemFontOfSize:17];
    label3.textColor = [UIColor colorFromHex:0x074765];
    label3.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    label3.textAlignment = 1;
    
    rect.origin.x = (cell.contentView.frame.size.width - 200 ) / 2;
    rect.size.width = 200;
    UILabel *label5 = [[UILabel alloc] initWithFrame:rect];
    label5.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    label5.backgroundColor = [UIColor clearColor];
    label5.tag = 105;
    [cell.contentView addSubview:label5];
    label5.font = [UIFont boldSystemFontOfSize:16];
    label5.textAlignment = 1;
    
    return cell;
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = nil;
    UILabel *label3 = (UILabel *)[cell.contentView viewWithTag:104];
    label3.text = nil;
    UILabel *label5 = (UILabel *)[cell.contentView viewWithTag:105];
    label5.text = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];
    imageView.image = nil;
#if FreeApp

    if (section == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"Restore", nil);
    }
    else if (section == 1)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"Send feedback", nil);
        }
        else{
            cell.textLabel.text = NSLocalizedString(@"Rate us", nil);
        }
    }
    else if (section == 2)
#else
    if (section == 0)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"Send feedback", nil);
        }
        else{
            cell.textLabel.text = NSLocalizedString(@"Rate us", nil);
        }
    }
    else if (section == 1)
#endif
    {
        if ([indexPath row] < [appArray count])
        {
            AppDesc *app = [appArray objectAtIndex:[indexPath row]];
            imageView.image = app.icon;
            label.text = app.name;
        }
        else
        {
             label5.text = NSLocalizedString(@"View more", nil);
        }
    }
    else if (section == 3)
    {
        cell.textLabel.text = NSLocalizedString(@"Version", nil);
        label3.text = @"2.1";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
#if FreeApp
    return 3;
#else
    return 2;
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#if FreeApp

    if (section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        return [appArray count] + 1;
    }
    else if (section == 0)
    {
        return 1;
    }
    
#else
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return [appArray count] + 1;
    }
#endif
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
#if FreeApp
    if (section == 0)
    {
        return NSLocalizedString(@"Restore", nil);
    }
    if (section == 1)
    {
        return NSLocalizedString(@"Feedback", nil);
    }
    else if (section == 2)
    {
        return NSLocalizedString(@"More Apps", nil);
    }
#else

    if (section == 0)
    {
        return NSLocalizedString(@"Feedback", nil);
    }
    else if (section == 1)
    {
        return NSLocalizedString(@"More Apps", nil);
    }
#endif
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self creatCellWithIndexPath:indexPath];
        
 
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    [self configCell:cell indexPath:indexPath];
     return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
#if FreeApp
    if (section == 0)
    {
        [iapHelper restoreIap];
    }
    else if (section == 1)
#else
    if (section == 0)
#endif
    {
        if (row == 0)
        {
            #if FreeApp
            [socila sendFeedback:NSLocalizedString(@"Emoji Keyboard 3.3", nil) body:nil];
            #else
            [socila sendFeedback:NSLocalizedString(@"Emoji Keyboard PRO 1.3", nil) body:nil];
            #endif
        }
        else
        {
            #if FreeApp
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/id648963730?mt=8"]];
            #else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/id645489866?mt=8"]];
            #endif
        }
    }
#if FreeApp
    else if (section == 2)
#else
    else if (section == 1)
#endif
    {
        if (row < [appArray count])
        {
            AppDesc *app = [appArray objectAtIndex:row];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.url]];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/artist/chen-shun/id623735008"]];
        }
    }
}
@end
