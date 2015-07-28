//
//  ExpandingCell.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 4..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinishDelegate <NSObject>

- (void)finishOrder;

@end

@interface ExpandingCell : UITableViewCell

@property (weak, nonatomic) id<FinishDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *callPhone;
@property (weak, nonatomic) IBOutlet UIButton *buttonFinish;

@end
