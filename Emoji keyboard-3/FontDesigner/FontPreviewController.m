//
//  FontPreviewController.m
//  FontDesigner
//
//  Created by chenshun on 13-5-6.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "FontPreviewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexColor.h"
#import "AppDelegate.h"
#include <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

#import "UIColor+HexColor.h"
#import "NSString+MessagesView.h"
#import "ArtEmojiViewController.h"

#import "PureLayout.h"

@interface FontPreviewController ()
{
    UIImageView *bubbleImageView;
    
}

@property (nonatomic, strong)NSLayoutConstraint *heightConstraint;
@end

@implementation FontPreviewController
@synthesize textView1;
@synthesize fontName, toolbar, symbolKeyboard, systemKeyButton, symbolKeyButton, fontKeyButton;
@synthesize aSlider;
@synthesize historySymbolKeyboard, emojiKeyButton, emojiSymbolKeyboard, deleteKeyButton, doneButton, unicodeKeyboard, currentFont;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Keyboard";
        self.tabBarItem.image = [UIImage imageNamed:@"keyboard.png"];
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
    
    [self setUpTextView];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorFromHex:0xf7f7f7];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        toolbar.barTintColor = [UIColor colorFromHex:0xc9ced4];
    }
    toolbar.tintColor = [UIColor blackColor];
    toolbar.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    toolbar.layer.borderWidth = 0.5;
    aSlider.value = 20;

    NSString *model = [UIDevice currentDevice].model;
    if ([model hasPrefix:@"iPad"] || [model hasSuffix:@"iPad"])
    {
        CGRect rect2 = textView1.frame;
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        rect2.origin.y = app.adBanner.frame.size.height + 5;
        textView1.frame = rect2;
    }

    social = [[TTSocial alloc] init];
    social.viewController = self;

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadFont:)
//                                                 name:@"changeFont"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadBanner:)
//                                                 name:@"reloadBanner"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadUnicodeSymbols:) name:@"ReloadSymbols" object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadFontKeyboard:) name:@"reloadFontKeyboard" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(insertBubbleText:) name:@"kSelectBubbuleText" object:nil];
    
    
    shareButton.tintColor = [UIColor darkGrayColor];
    trashButton.tintColor = [UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItems = @[shareButton, trashButton];
    
    self.symbolKeyboard = [[SymbolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    self.symbolKeyboard.delegate = self;
    [self.symbolKeyboard setSymbolShowType:ST_Symbol];
    textView1.inputAccessoryView = toolbar;
    
    self.historySymbolKeyboard = [[SymbolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    [self.historySymbolKeyboard setSymbolShowType:ST_History];
    self.historySymbolKeyboard.delegate = self;
    
    self.emojiSymbolKeyboard = [[SymbolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    [self.emojiSymbolKeyboard setSymbolShowType:ST_Emoji];
    self.emojiSymbolKeyboard.delegate = self;
    
    coolFontViewController = [[CoolFontViewController alloc] initWithNibName:@"CoolFontViewController" bundle:nil];

    [self addUnicodeView];
    
    textView1.inputView = self.symbolKeyboard;

    
    showSystemKeyboard = NO;

}

- (void)setUpTextView
{
    bubbleImageView = [UIImageView newAutoLayoutView];
    [self.view addSubview:bubbleImageView];
    bubbleImageView.image = [[UIImage imageNamed:@"bubbleSelected.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:15];
    [bubbleImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0];
    [bubbleImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15.0];
    [bubbleImageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:150.0];
    bubbleImageView.userInteractionEnabled = YES;
    
    [UIView autoSetPriority:(UILayoutPriorityRequired - 1) forConstraints:^{
        
        self.heightConstraint = [bubbleImageView autoSetDimension:ALDimensionHeight toSize:150.0];
    }];
    
    [bubbleImageView autoSetDimension:ALDimensionHeight toSize:150.0 relation:NSLayoutRelationGreaterThanOrEqual];
    [bubbleImageView autoSetDimension:ALDimensionHeight toSize:250.0 relation:NSLayoutRelationLessThanOrEqual];
    
    self.textView1 = [UITextView newAutoLayoutView];
    [bubbleImageView addSubview:self.textView1];
    [self.textView1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0];
    [self.textView1 autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
    [self.textView1 autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:25.0];
    [self.textView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0];
    textView1.delegate = self;
    textView1.backgroundColor = [UIColor clearColor];
    textView1.font = [UIFont systemFontOfSize:20];
    textView1.backgroundColor = [UIColor redColor];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gwl_inputTextDidChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)gwl_inputTextDidChanged:(NSNotification *)notification
{
    if (self.heightConstraint)
    {
        float newHeight = [textView1 sizeThatFits:textView1.frame.size].height;
        self.heightConstraint.constant = newHeight + 16.0;
        [bubbleImageView layoutIfNeeded];
//        当你清空输入框时(_textView.text=@"";)，不会自动触发textChanged:，你需要重写setText:方法来调用textChanged
        [textView1 scrollRangeToVisible:textView1.selectedRange];
    }
}

- (void)insertBubbleText:(NSNotification *)notice
{
    NSString *str = [notice object];
    [textView1 insertText:str];
}

- (IBAction)upgradeAction:(id)sender
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade" message:@"Upgrade to pro version to unlock all emoticons and art text without any ads and restrictions.Purchase now?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Purchase", nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome feature!" message:@"Upgrade to pro version to have more cute emojis emoticons, symbols and fonts, link them to your iPhone/iPad,And No Ads!" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Upgrade", nil];
    [alert show];
    alert.tag = 1000;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/id662538696?mt=8"]];
    }
}

- (void)addUnicodeView
{
    unicodeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    unicodeView.pagingEnabled = YES;
    unicodeView.showsHorizontalScrollIndicator = YES;
    unicodeView.showsVerticalScrollIndicator = NO;
    unicodeView.delegate = self;
    unicodeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    unicodeView.contentSize = CGSizeMake(self.view.frame.size.width, 216 * 2);
    unicodeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    symbolListController = [[SymbolListViewController alloc] initWithNibName:@"SymbolListViewController" bundle:nil];
    symbolListController.view.frame = CGRectMake(0, 216, self.view.frame.size.width, 216);
    [unicodeView addSubview:symbolListController.view];
    
    SymbolUnits *symbolUnits = [symbolListController.symbolListArray objectAtIndex:0];
    self.unicodeKeyboard = [[SymbolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    [self.unicodeKeyboard showSymbols:symbolUnits];
    self.unicodeKeyboard.delegate = self;
    [unicodeView addSubview:unicodeKeyboard];
    unicodeKeyboard.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [unicodeView setContentOffset:CGPointMake(0, 216) animated:YES];
}

- (void)reloadUnicodeSymbols:(NSNotification *)notificaiton
{
    SymbolUnits *units = (SymbolUnits *)[notificaiton object];
    [self.unicodeKeyboard showSymbols:units];
    
    [unicodeView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)coolFontKeyboard:(id)sender
{
    textView1.inputView = coolFontViewController.view;
    [textView1 reloadInputViews];
}

- (void)reloadFontKeyboard:(NSNotification *)notificaiton
{

    {
        self.currentFont = [notificaiton object];
        textView1.inputView = nil;
        [textView1 reloadInputViews];
    }

}

- (void)reloadFont:(NSNotification *)notificaiton
{

    self.fontName = (NSString *)[notificaiton object];
    textView1.font = [UIFont fontWithName:self.fontName size:aSlider.value];
}

- (IBAction)unicode:(id)sender
{
    [unicodeView setContentOffset:CGPointMake(0, 216) animated:YES];
    textView1.inputView = unicodeView;
    [textView1 reloadInputViews];
}

- (void)reloadBanner:(NSNotification *)notificaiton
{
#if FreeApp
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.adBanner.superview != nil)
    {
        [app.adBanner removeFromSuperview];
    }

    {
        CGRect rect = app.adBanner.frame;
        rect.origin.y = 0;
        app.adBanner.frame = rect;
        app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:app.adBanner];
    }


#endif
}

- (IBAction)shareAction:(id)sender
{
    if ([self.textView1.text length] == 0)
    {
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"SMS", nil),
                                  NSLocalizedString(@"Email", nil),
                                  NSLocalizedString(@"Add to Favorites", nil),
                                  NSLocalizedString(@"Copy", nil),
                                  nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.delegate = self;
	[actionSheet showInView:self.tabBarController.view];
   
}

- (IBAction)clearAction:(id)sender
{
     textView1.text = nil;
}

- (IBAction)showProVersion:(id)sender
{
    textView1.text = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self reloadBanner:nil];
    oldRect = textView1.frame;
    [self performSelector:@selector(beganEding) withObject:nil afterDelay:0.1];
}

- (void)beganEding
{
    [textView1 becomeFirstResponder];
}

- (IBAction)symbolKeyboard:(id)sender
{
    textView1.inputView = self.symbolKeyboard;
    [textView1 reloadInputViews];
}

- (IBAction)systemKeyboard:(id)sender
{
    textView1.inputView = nil;
    [textView1 reloadInputViews];
    self.currentFont = nil;
}

- (IBAction)historyKeyboard:(id)sender
{
    [self.historySymbolKeyboard setSymbolShowType:ST_History];
    textView1.inputView = self.historySymbolKeyboard;
    [textView1 reloadInputViews];
}

- (IBAction)emojiKeyboard:(id)sender
{
    textView1.inputView = self.symbolKeyboard;
    [textView1 reloadInputViews];
}

- (IBAction)hideKeyboard:(id)sender
{
    [textView1 setContentOffset:CGPointZero animated:YES];
    [textView1 resignFirstResponder];
}


- (IBAction)deleteBackwardString:(id)sender
{
    [textView1 deleteBackward];
}

- (IBAction)artText:(id)sender
{
    ArtEmojiViewController *artController = [[ArtEmojiViewController alloc] initWithNibName:@"ArtEmojiViewController" bundle:nil];
    artController.hidesBottomBarWhenPushed = YES;
    artController.showPromtAd = NO;
    artController.editMode = YES;
    [self.navigationController pushViewController:artController animated:YES];
}

- (IBAction)insertSpace:(id)sender
{
    [textView1 insertText:@" "];
}

- (IBAction)insertReturn:(id)sender
{
    [textView1 insertText:@"\n"];
}

- (IBAction)changeFont:(id)sender
{

}

- (IBAction)changeFontSize:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    if (self.fontName != nil)
    {
        textView1.font = [UIFont fontWithName:self.fontName size:slider.value];
    }
    else
    {
        textView1.font = [UIFont systemFontOfSize:slider.value];
    }
}

- (IBAction)hideKey:(id)sender
{
    [textView1 resignFirstResponder];
}

- (IBAction)historySymbol:(id)sender
{
    
}

- (NSString *)fileName
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMdd-HH-mm-ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)saveText
{
    if ([self.textView1.text length] == 0)
    {
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Favorites"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:[self fileName]];
    [self.textView1.text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *normalText = [text uppercaseString];
    if (self.currentFont != nil)
    {
        NSString *mapStr = [self.currentFont mapStrForNormal:normalText];
        if (mapStr != nil)
        {
            [textView1 insertText:mapStr];
            return NO;
        }
    }

    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [textView1 resignFirstResponder];
        [social showSMSPicker:textView1.text phones:nil];
    }
    else if (buttonIndex == 1)
    {
        [textView1 resignFirstResponder];
        [social showMailPicker:textView1.text to:nil cc:nil bcc:nil images:nil];
    }
    else if (buttonIndex == 2)
    {
        [self saveText];
    }
    else if (buttonIndex == 3)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = textView1.text;
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
//    NSTimeInterval animationDuration =
//    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    CGRect convRect = [window convertRect:keyboardRect toView:self.view];
//
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    CGRect textViewRect = self.textView1.frame;
//    textViewRect.size.height = abs(self.textView1.frame.origin.y - convRect.origin.y);
//    self.textView1.frame = textViewRect;
//    //bottom = textViewRect.size.height + textView1.frame.origin.y;
//    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
//    NSTimeInterval animationDuration =
//    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.textView1.frame = oldRect;
//    [UIView commitAnimations];
}

- (void)textDidChange:(NSNotification *)notice
{
//    CGRect rect = textView1.frame;
//    rect.size = textView1.contentSize;
//    if (rect.size.height + rect.origin.y >= bottom)
//    {
//        rect.size.height = bottom - rect.origin.y;
//    }
//    
//    textView1.frame = rect;
}

- (void)selectSymbol:(NSString *)text
{
    [textView1 insertText:text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
