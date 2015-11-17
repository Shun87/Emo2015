//
//  SymbolUnits.m
//  TextFont
//
//  Created by chenshun on 13-6-17.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "SymbolUnits.h"

@implementation SymbolUnits
@synthesize symbolArray, symbolID, name, unicodeVal;

- (void)dealloc
{

}

- (id)init
{
    if (self = [super init])
    {
        symbolArray =[[NSMutableArray alloc]init];
    }
    
    return self;
}

@end
