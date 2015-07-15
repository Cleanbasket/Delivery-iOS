//
//  FirstViewController.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 2..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "ExpandingCell.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FinishDelegate> {
    NSInteger selectedIndex;
    NSMutableArray *titleArray;
    NSArray *subtitleArray;
    NSArray *textArray;
}

@property NSMutableArray<Order> *dataRawArray;
@property NSMutableArray<Order> *dataArray;
@property (strong, nonatomic) UIButton *buttonFinish;

@end

