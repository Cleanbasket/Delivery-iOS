//
//  Order.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 27..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBConstants.h"
#import "Coupon.h"
#import "Item.h"
#import "PickupInfo.h"

@protocol Order
@end

@interface Order : NSObject <NSURLConnectionDataDelegate>
@property long oid;
@property NSString *addr_building;
@property NSString *addr_number;
@property NSString *addr_remainder;
@property NSString *address;
@property NSArray<Coupon> *coupon;
@property NSString *dropoff_date;
@property long dropoff_man;
@property long dropoff_price;
@property NSArray<Item> *item;
@property NSString *memo;
@property NSString *order_number;
@property NSString *phone;
@property PickupInfo *pickupInfo;
@property NSString *pickup_date;
@property long pickup_man;
@property long price;
@property NSString *rdate;
@property long state;
@property NSDate *order_date;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
