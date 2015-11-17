//
//  FontPreviewController.h
//  FontDesigner
//
//  Created by chenshun on 13-5-6.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SymbolView.h"
#import "TTSocial.h"
#import "SymbolListViewController.h"
#import "CoolFontViewController.h"

@interface FontPreviewController : UIViewController<SymbolViewDelegate, UIActionSheetDelegate, UITextViewDelegate>
{
    UITextView *textView1;
    CGRect oldRect;
    NSString *fontName;
    UIToolbar *toolbar;
    SymbolView *symbolKeyboard;
    SymbolView *historySymbolKeyboard;
    SymbolView *emojiKeyboard;
    
    UIBarButtonItem *systemKeyButton;
    UIBarButtonItem *symbolKeyButton;
    UIBarButtonItem *fontKeyButton;
    UIBarButtonItem *emojiKeyButton;
    UIBarButtonItem *deleteKeyButton;
    
    IBOutlet UIBarButtonItem *shareButton;
    UIBarButtonItem *doneButton;
    TTSocial *social;
    UISlider *aSlider;
    
    
    BOOL showshowSystemKey;
    
    SymbolListViewController *symbolListController;
    SymbolView *unicodeKeyboard;
    CoolFontViewController *coolFontViewController;
    CoolFont *currentFont;
    
    CGFloat bottom;
}
@property (nonatomic, retain)IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain)IBOutlet UISlider *aSlider;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *fontKeyButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *symbolKeyButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *systemKeyButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *emojiKeyButton;
@property (nonatomic, retain)IBOutlet UIBarButtonItem *deleteKeyButton;
@property (nonatomic, retain)SymbolView *symbolKeyboard;
@property (nonatomic, retain)SymbolView *historySymbolKeyboard;
@property (nonatomic, retain)SymbolView *emojiKeyboard;
@property (nonatomic, retain)SymbolView *unicodeKeyboard;
@property (nonatomic, retain)IBOutlet UIToolbar *toolbar;
@property (nonatomic, copy)NSString *fontName;
@property (nonatomic, retain) UITextView *textView1;
@property (nonatomic, retain)CoolFont *currentFont;

- (IBAction)symbolKeyboard:(id)sender;
- (IBAction)systemKeyboard:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)changeFont:(id)sender;
- (IBAction)historySymbol:(id)sender;
- (IBAction)deleteBackwardString:(id)sender;
- (IBAction)changeFontSize:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)unicode:(id)sender;
- (IBAction)coolFontKeyboard:(id)sender;

- (IBAction)artText:(id)sender;
- (IBAction)insertSpace:(id)sender;
- (IBAction)insertReturn:(id)sender;
@end
