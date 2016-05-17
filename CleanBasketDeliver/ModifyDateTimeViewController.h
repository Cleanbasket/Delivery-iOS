//
//  ModifyDateTimeViewController.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 20..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyDateTimeViewController : UIViewController {
    NSDictionary *orderData;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *pickupDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dropoffDatePicker;

- (void)setOrder:(NSDictionary *)order;


@end
