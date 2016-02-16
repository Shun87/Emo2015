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
#import "BubbleView.h"

#import "ModalSpreadApp.h"

@interface FontPreviewController ()
{
    UIImageView *bubbleImageView;
    UIView *toolView;
    
    NSLayoutConstraint *maxHeightConstraint;
}
@property (nonatomic, strong)UIButton *selectButton;
@property (nonatomic, strong)NSMutableArray *buttons;
@property (nonatomic, strong)NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong)UIButton *deleteButton;
@end

@implementation FontPreviewController
@synthesize textView1;
@synthesize fontName, toolbar, symbolKeyboard, systemKeyButton, symbolKeyButton, fontKeyButton;
@synthesize aSlider;
@synthesize historySymbolKeyboard, emojiKeyButton, emojiKeyboard, deleteKeyButton, doneButton, unicodeKeyboard, currentFont;

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
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.tabBarController.tabBar.translucent = NO;
    }


    self.buttons = [[NSMutableArray alloc] init];
    
    [self setUpTextView];
    [self setUpToolView];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorFromHex:0xececec];
    
    [fontKeyButton setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_top"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    
    [systemKeyButton setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_top"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    [symbolKeyButton setBackgroundImage:[UIImage imageNamed:@"button_keyboard_top"] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    [emojiKeyButton setBackgroundImage:[UIImage imageNamed:@"button_keyboard_top"] forState:UIControlStateNormal  style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];

    [fontKeyButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [systemKeyButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [symbolKeyButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [emojiKeyButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    social = [[TTSocial alloc] init];
    social.viewController = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadFontKeyboard:) name:@"reloadFontKeyboard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertBubbleText:) name:@"kSelectBubbuleText" object:nil];
    
    
    shareButton.tintColor = [UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem = shareButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Text Arts" style:UIBarButtonItemStyleBordered target:self action:@selector(artText:)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSInteger height = [SymbolView calculateHeight];
    self.symbolKeyboard = [[SymbolView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, height)];
    self.symbolKeyboard.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.symbolKeyboard.delegate = self;
    self.symbolKeyboard.backgroundColor = [UIColor colorFromHex:0xebeef1];
    [self.symbolKeyboard setSymbolShowType:ST_Symbol];
    
    self.emojiKeyboard = [[SymbolView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, height)];
    self.emojiKeyboard.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.emojiKeyboard.delegate = self;
    self.emojiKeyboard.backgroundColor = [UIColor colorFromHex:0xebeef1];
    [self.emojiKeyboard setSymbolShowType:ST_Emoji];
    
    [self showEmojiKey:[self.buttons firstObject]];
    fontView = [[CoolFontView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, height)];
    fontView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)setUpToolView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.bounds.size.width, 35)];
    toolView.backgroundColor = [UIColor blackColor];
    UIButton *fontButton = [self addButton:@"Font" sel:@selector(showFontKey:)];
    UIButton *emojiButton = [self addButton:@"Emoji" sel:@selector(showEmojiKey:)];
    UIButton *extraButton = [self addButton:@"Extra" sel:@selector(showExtraKey:)];
    UIButton *abcButton = [self addButton:@"ABC" sel:@selector(showSystemKey:)];
    UIButton *doneButton2 = [self addButton:@"Done" sel:@selector(hideKeyboard:)];
    NSArray *array = @[emojiButton, extraButton, fontButton, abcButton, doneButton2];
    [self.buttons addObjectsFromArray:array];
    [array autoSetViewsDimension:ALDimensionHeight toSize:35];
    [emojiButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [array autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:0.0 insetSpacing:YES matchedSizes:YES];
    textView1.inputAccessoryView = toolView;
}

- (UIButton *)addButton:(NSString *)title sel:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [toolView addSubview:button];
    [button setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_active"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_select"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setUpTextView
{
    bubbleImageView = [UIImageView newAutoLayoutView];
    [self.view addSubview:bubbleImageView];
    bubbleImageView.image = [[UIImage imageNamed:@"bubbleSelected.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:15];
    [bubbleImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:55.0];
    [bubbleImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15.0];
    [bubbleImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withMultiplier:0.85];
    bubbleImageView.userInteractionEnabled = YES;
    
    [UIView autoSetPriority:(UILayoutPriorityRequired - 1) forConstraints:^{
        
        self.heightConstraint = [bubbleImageView autoSetDimension:ALDimensionHeight toSize:90.0];
    }];
    
    [bubbleImageView autoSetDimension:ALDimensionHeight toSize:90.0 relation:NSLayoutRelationGreaterThanOrEqual];
    maxHeightConstraint = [bubbleImageView autoSetDimension:ALDimensionHeight toSize:250.0 relation:NSLayoutRelationLessThanOrEqual];
    
    self.textView1 = [UITextView newAutoLayoutView];
    [bubbleImageView addSubview:self.textView1];
    [self.textView1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0];
    [self.textView1 autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
    [self.textView1 autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:25.0];
    [self.textView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0];
    textView1.delegate = self;
    textView1.backgroundColor = [UIColor clearColor];
    textView1.font = [UIFont systemFontOfSize:20];
    textView1.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gwl_inputTextDidChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [bubbleImageView addSubview:self.deleteButton];
    [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.deleteButton autoSetDimensionsToSize:CGSizeMake(40, 30)];
    [self.deleteButton setImage:[UIImage imageNamed:@"close_button_white"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.hidden = YES;
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

- (void)gwl_inputTextDidChanged:(NSNotification *)notification
{
    self.deleteButton.hidden = [textView1.text length] == 0;
    if (textView1.text == nil)
    {
        self.heightConstraint.constant = 90.0;
        [bubbleImageView layoutIfNeeded];
        return;
        NSLog(@"%@", textView1.text);
    }
    if (self.heightConstraint)
    {
        float newHeight = 0.0;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        {
            newHeight = [self sizeForString:textView1.text font:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(textView1.frame.size.width, 2000) lineBreakMode:NSLineBreakByWordWrapping].height;
        }
        else
        {
             newHeight = [textView1.text sizeWithFont:[UIFont systemFontOfSize:20]
                   constrainedToSize:CGSizeMake(textView1.frame.size.width, 2000)
                       lineBreakMode:NSLineBreakByWordWrapping].height;
        }

        
        self.heightConstraint.constant = newHeight + 16.0;
        [bubbleImageView setNeedsLayout];
        [bubbleImageView layoutIfNeeded];
        [textView1 layoutIfNeeded];
//        当你清空输入框时(_textView.text=@"";)，不会自动触发textChanged:，你需要重写setText:方法来调用textChanged
        [textView1 scrollRangeToVisible:textView1.selectedRange];
    }
}

- (void)insertBubbleText:(NSNotification *)notice
{
    NSString *str = [notice object];
    [textView1 insertText:str];
    [self gwl_inputTextDidChanged:nil];
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

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadFontKeyboard:(NSNotification *)notificaiton
{
    self.currentFont = [notificaiton object];
    textView1.inputView = nil;
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

    if ([app showAds])
    {
        CGRect rect = app.adBanner.frame;
        rect.origin.y = 0;
        app.adBanner.frame = rect;
        app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:app.adBanner];
    }
    else
    {
        app.adBanner = nil;
    }

#endif

}

- (IBAction)shareAction:(id)sender
{
    [[UserParameter sharedInstance] doSwitchAction];
    if ([self.textView1.text length] == 0)
    {
        return;
    }
    
    [textView1 resignFirstResponder];
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
    if (self.tabBarController.view != nil)
    {
        [actionSheet showInView:self.tabBarController.view];
    }
    else
    {
        [actionSheet showInView:self.view];
    }
}

- (IBAction)clearAction:(id)sender
{
     textView1.text = nil;
    [self gwl_inputTextDidChanged:nil];
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
    [self performSelector:@selector(showOtherApp) withObject:nil afterDelay:1];
}

- (void)showOtherApp
{
    [[ModalSpreadApp sharedInstance] showOtherApp];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)beganEding
{
    [textView1 becomeFirstResponder];
}

- (IBAction)showExtraKey:(id)sender
{
    textView1.inputView = self.symbolKeyboard;
    [textView1 reloadInputViews];
    [self changeButtonImage:sender track:YES];
    
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
}

- (IBAction)showEmojiKey:(id)sender
{
    textView1.inputView = self.emojiKeyboard;
    [textView1 reloadInputViews];
    [self changeButtonImage:sender track:YES];
    
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
}

- (IBAction)showSystemKey:(id)sender
{
    textView1.inputView = nil;
    [textView1 reloadInputViews];
    self.currentFont = nil;
    [self changeButtonImage:sender track:YES];
    
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
}

- (IBAction)showFontKey:(id)sender
{
    fontView.curFont = self.currentFont;
    textView1.inputView = fontView;
    [textView1 reloadInputViews];
    [self changeButtonImage:sender track:YES];
    
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
}

- (IBAction)hideKeyboard:(id)sender
{
    [textView1 setContentOffset:CGPointZero animated:YES];
    [textView1 resignFirstResponder];
    
    [[UserParameter sharedInstance] doSwitchAction];
    [[RateAppView sharedInstance] showRateView];
}

- (void)changeButtonImage:(UIButton *)button track:(BOOL)trackStatus
{
    if (self.selectButton != nil && self.selectButton != button)
    {
        [self.selectButton setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_active"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
    }
    
    self.selectButton = button;
    
    if (trackStatus)
    {
            [self.selectButton setBackgroundImage:[[UIImage imageNamed:@"button_keyboard_select"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
    }
}

- (IBAction)deleteBackwardString:(id)sender
{
    [textView1 deleteBackward];
}

- (IBAction)artText:(id)sender
{
    [[UserParameter sharedInstance] doSwitchAction];
    ArtEmojiViewController *artController = [[ArtEmojiViewController alloc] initWithNibName:@"ArtEmojiViewController" bundle:nil];
    artController.hidesBottomBarWhenPushed = YES;
    artController.showPromtAd = NO;
    artController.showByFontKeyboard = YES;
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
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Favorites_Text.plist"];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithContentsOfFile:path];
    if ([mutableArray count] == 0)
    {
        mutableArray = [[NSMutableArray alloc] init];
    }
    
    [mutableArray addObject:self.textView1.text];
    [mutableArray writeToFile:path atomically:YES];
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
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect convRect = [window convertRect:keyboardRect toView:self.view];
    CGRect textViewRect = self.textView1.frame;
    maxHeightConstraint.constant = abs(self.textView1.frame.origin.y - convRect.origin.y) - 55;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
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
