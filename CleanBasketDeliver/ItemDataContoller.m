//
//  ItemDataContoller.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 28..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "ItemDataContoller.h"
#import "item.h"
#import "AFNetworking.h"

@interface ItemDataContoller()
@property (nonatomic, readonly) NSMutableArray *itemList;
-(void) initializeDefaultItem;
@end

@implementation ItemDataContoller {
    AFHTTPRequestOperationManager *afManager;
}

- (id) init {
    self = [super init];
    
    if (self) {
        _itemList = [[NSMutableArray alloc] init];
        [self initializeDefaultItem];
        return self;
    }
    
    return nil;
}

- (void)initializeDefaultItem {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"ITEM"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    [afManager GET:[NSString stringWithFormat:@"%@%@", root, address] parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self addItems:[NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                          options: NSJSONReadingMutableContainers
                                                      error: nil]];
        
        [self.delegate dataChange];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)addItems:(NSMutableArray *)array {
    for (NSDictionary *item in array) {
        [self addItemWithTitle:[[item objectForKey:@"itid"] integerValue] name:[item objectForKey:@"name"] price:[[item objectForKey:@"price"] integerValue] count:[[item objectForKey:@"count"] integerValue]];
    }
}

- (void)addItemWithTitle:(NSInteger)itid name:(NSString *)name price:(NSInteger)price count:(NSInteger)count {
    Item *newItem = [[Item alloc] initWithTitle:itid name:name price:price count:count];
    
    [self.itemList addObject:newItem];
}

- (NSUInteger)itemCount {
    return [self.itemList count];
}

- (Item *)itemAtIndex:(NSUInteger)index {
    return [self.itemList objectAtIndex:index];
}

@end
