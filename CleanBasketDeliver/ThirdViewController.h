//
//  ThirdViewController.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 13..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "order.h"

@interface ThirdViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    int selectedIndex;
    NSMutableArray *titleArray;
    NSArray *subtitleArray;
    NSArray *textArray;
}

@property NSArray<Order> *dataDropOffArray;
@property (strong, nonatomic) UIButton *buttonFinish;

@end
