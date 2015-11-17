//
//  ModalSpreadApp.h
//  Emoji keyboard
//
//  Created by tsinglink on 15/11/17.
//  Copyright © 2015年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalSpreadApp : NSObject
+(ModalSpreadApp *)sharedInstance;
- (void)showMore3D;
- (void)showOtherApp;
@end
