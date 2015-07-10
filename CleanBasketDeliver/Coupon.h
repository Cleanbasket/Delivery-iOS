//
//  Coupon.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 27..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Coupon
@end

@interface Coupon : NSObject
@property int cpid;
@property NSString *name;
@property NSString *descr;
@property int type;
@property int kind;
@property BOOL infinite;
@property int value;
@property NSString *img;
@property NSString *start_date;
@property NSString *end_date;
@property NSString *rdate;

@end
