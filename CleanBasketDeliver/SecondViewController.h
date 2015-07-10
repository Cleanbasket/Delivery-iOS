//
//  SecondViewController.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 2..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    int selectedIndex;
    NSMutableArray *titleArray;
    NSArray *subtitleArray;
    NSArray *textArray;
}

@property NSArray<Order> *dataDropOffArray;
@property (strong, nonatomic) UIButton *buttonFinish;
@end
