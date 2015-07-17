//
//  OrderCell.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 17..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell
@synthesize pickUpLabel, dropOffLabel, orderNumberLabel, addressLabel, contactLabel, priceLabel, itemLabel, memoLabel, couponLabel, mileageLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
