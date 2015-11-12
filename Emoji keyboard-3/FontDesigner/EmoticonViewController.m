//
//  EmoticonViewController.m
//  Characters
//
//  Created by chenshun on 13-7-8.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "EmoticonViewController.h"
#import "AppDelegate.h"

@interface EmoticonViewController ()

@end

@implementation EmoticonViewController
@synthesize image, emtionTitle, selectIndex, imagePath;
- (void)dealloc{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Emoticon", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"emoji.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
#endif
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = emtionTitle;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    array = [[NSMutableArray alloc] init];
    mTableView.rowHeight = 120;
    
     NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *dir = [bundlePath stringByAppendingPathComponent:@"PRO"];
    if (self.animated)
    {
        dir = [bundlePath stringByAppendingPathComponent:@"Animated"];
    }
    NSString *gifDir = emtionTitle;
    
    gifDir = [dir stringByAppendingPathComponent:gifDir];
    NSArray *gifPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:gifDir error:nil];
    
    for (int j=0; j<[gifPaths count]; j++)
    {
        NSString *gifFilePath = [gifDir stringByAppendingPathComponent:[gifPaths objectAtIndex:j]];
        [array addObject:gifFilePath];
    }
    social = [[TTSocial alloc] init];
    social.viewController = self;
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectImage:(UIImage *)aimage at:(NSInteger)index cell:(UITableViewCell *)tableCell
{
    NSIndexPath *indexPath = [mTableView indexPathForCell:tableCell];
    NSInteger aIndex = [indexPath row] * 3 + index;
    self.imagePath = [array objectAtIndex:aIndex];
    BOOL showActionSheet = NO;
    int nMax = 4;
    if (!self.animated)
    {
        nMax = 7;
    }

    
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles: @"Text Message",
                                      NSLocalizedString(@"Email", nil),
                                      NSLocalizedString(@"Copy", nil),
                                      nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.delegate = self;
        [actionSheet showInView:self.tabBarController.view];


}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        {
            if ([MFMessageComposeViewController canSendAttachments])
            {
                if (self.animated)
                {
                    NSString *fileName = [NSString stringWithFormat:@"%u.gif", (u_int)[[NSDate date] timeIntervalSince1970]]
                    ;
                    [social displaySMSComposerSheet:nil attachments:[NSData dataWithContentsOfFile:self.imagePath]
                                                uti:@"com.compuserve.gif"
                                               name:fileName];
                }
                else
                {
                    NSString *fileName = [NSString stringWithFormat:@"%u.png", (u_int)[[NSDate date] timeIntervalSince1970]]
                    ;
                    [social displaySMSComposerSheet:nil attachments:[NSData dataWithContentsOfFile:self.imagePath]
                                                uti:@"public.png"
                                               name:fileName];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Please make sure you have enabled iMessage or MMS in Settings->Messages, then try again."
                                                               delegate:(id <UIAlertViewDelegate>)self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"OK", nil];
                alert.tag = 1002;
                [alert show];
            }
        }
        else
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            if (!self.animated)
            {
                [pasteboard setData:[NSData dataWithContentsOfFile:self.imagePath] forPasteboardType:@"public.png"];
            }
            else
            {
                [pasteboard setData:[NSData dataWithContentsOfFile:self.imagePath] forPasteboardType:@"com.compuserve.gif"];
            }
            
            BOOL promt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"promted"] boolValue];
            if (!promt)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Make sure you have enable iMessage or MMS in Settings->Messages, then Operating according to the following steps:1.Tap Send 2.Choose the recipient(must have iMessage or MMS) \n 3.Tap and hold message field to Paste 4.Send"
                                                               delegate:(id <UIAlertViewDelegate>)self
                                                      cancelButtonTitle:@"Don't promt again"
                                                      otherButtonTitles:@"Send", nil];
                alert.tag = 1001;
                [alert show];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
            }
        }
    }
    else if (buttonIndex == 1)
    {
        if (!self.animated)
        {
            UIImage *toImage = [UIImage imageWithContentsOfFile:self.imagePath];
            [social showMailPicker:nil to:nil cc:nil bcc:nil images:[NSArray arrayWithObjects:toImage, nil]];
        }
        else
        {
            [social showMailPicker:nil to:nil imagePath:self.imagePath];
        }
    }
    else if (buttonIndex == 2)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (!self.animated)
        {
            [pasteboard setData:[NSData dataWithContentsOfFile:self.imagePath] forPasteboardType:@"public.png"];
        }
        else
        {
            [pasteboard setData:[NSData dataWithContentsOfFile:self.imagePath] forPasteboardType:@"com.compuserve.gif"];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001)
    {
        if (buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"promted"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if FreeApp
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.adBanner.superview != nil)
    {
        [app.adBanner removeFromSuperview];
    }

    
        CGRect rect = app.adBanner.frame;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        app.adBanner.frame = rect;
        app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:app.adBanner];
    

#else

#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count] / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    EmoticonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EmoticonCell alloc] initWithImageCount:3 style:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = [indexPath row];
    NSRange range;
    range.location = 3 * row;
    range.length = 3;
    [cell setImages:[array subarrayWithRange:range]];
    
    return cell;
}

@end
