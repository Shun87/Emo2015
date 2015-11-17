//
//  SymbolUnits.h
//  TextFont
//
//  Created by chenshun on 13-6-17.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SymbolUnits : NSObject
{
    NSString *name;
    NSMutableArray *symbolArray;
    NSInteger symbolID;
    NSString *unicodeVal;
}
@property (nonatomic, copy)NSString *unicodeVal;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, retain)NSMutableArray *symbolArray;
@property (nonatomic)NSInteger symbolID;
@end
