//
//  Item.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 27..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Item
@end

@interface Item : NSObject
@property NSInteger itid;
@property int oid;
@property int item_code;
@property NSString *name;
@property NSString *descr;
@property NSInteger price;
@property NSInteger count;
@property NSString *img;
@property NSString *rdate;

-(id)initWithTitle:(NSInteger)itid name:(NSString *)name price:(NSInteger)price count:(NSInteger)count;

@end
