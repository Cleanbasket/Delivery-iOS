//
//  ItemDataContoller.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 28..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@protocol DataChangeDelegate <NSObject>

- (void)dataChange;

@end

@interface ItemDataContoller : NSObject

@property (weak, nonatomic) id<DataChangeDelegate> delegate;
- (NSUInteger)itemCount;
- (Item *)itemAtIndex:(NSUInteger)index;
- (void)addItemWithTitle:(NSInteger)itid name:(NSString *)name price:(NSInteger)price count:(NSInteger)count;

@end
