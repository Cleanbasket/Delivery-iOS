//
//  Item.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 27..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id)initWithTitle:(NSInteger)itid name:(NSString *)name price:(NSInteger)price count:(NSInteger)count {
    self = [super init];
    if (self) {
        _itid = itid;
        _name = name;
        _price = price;
        _count = count;
        
        return self;
    }
    
    return nil;
}

@end
