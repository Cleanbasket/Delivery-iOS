//
//  FirstViewController.h
//  CleanBasketDeliver
//
//  Created by Theodore Yongbin Cha on 2015. 7. 15..
//  Copyright (c) 2016년 WashAppKorea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "ExpandingCell.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FinishDelegate> {
    NSInteger selectedIndex;
}

@property NSMutableArray<Order> *dataRawArray;
@property NSMutableArray *dataArray;
@property (strong, nonatomic) UIButton *buttonFinish;

@end

