//
//  Order.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 27..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "Order.h"

@implementation Order
@synthesize oid, addr_building, addr_number, addr_remainder, address, coupon;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.oid = [dictionary[@"oid"] longValue];
        self.addr_building = dictionary[@"addr_building"];
        self.addr_number = dictionary[@"addr_number"];
        self.addr_remainder = dictionary[@"addr_remainder"];
        self.address = dictionary[@"address"];
        self.coupon = dictionary[@"coupon"];
        self.dropoff_date = dictionary[@"dropoff_date"];
        self.dropoff_man = [dictionary[@"dropoff_man"] longValue];
        self.dropoff_price = [dictionary[@"dropoff_price"] longValue];
        self.item = dictionary[@"item"];
        self.memo = dictionary[@"memo"];
        self.order_number = dictionary[@"order_number"];
        self.phone = dictionary[@"phone"];
        self.pickupInfo = dictionary[@"pickupInfo"];
        self.pickup_date = dictionary[@"pickup_date"];
        self.pickup_man = [dictionary[@"pickup_man"] longValue];
        self.price = [dictionary[@"price"] longValue];
        self.rdate = dictionary[@"rdate"];
        self.state = [dictionary[@"state"] integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
        
        if (self.state < 3) self.order_date = [dateFormatter dateFromString:self.pickup_date];
        else self.order_date = [dateFormatter dateFromString:self.dropoff_date];
    }
    
    return self;
}

@end
