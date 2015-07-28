//
//  AssignCell.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 29..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinishAssignDelegate <NSObject>

- (void)finishOrder;

@end

@interface AssignCell : UITableViewCell <UIActionSheetDelegate>
@property (weak, nonatomic) id<FinishAssignDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *assignButton;
@property (weak, nonatomic) IBOutlet UIButton *callPhone;

@end
