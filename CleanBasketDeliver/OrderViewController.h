//
//  OrderViewController.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 17..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "order.h"
#import "OrderCell.h"

@interface OrderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SegueDelegate> {
    NSInteger selectedIndex;
}

@property NSMutableArray<Order> *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *loadOrder;

@end
