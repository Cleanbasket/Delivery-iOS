//
//  OrderCell.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 17..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell
@synthesize pickUpLabel, dropOffLabel, orderNumberLabel, addressLabel, contactLabel, priceLabel, itemLabel, memoLabel, couponLabel, mileageLabel, noteLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [contactLabel text]]]];
}

- (IBAction)modifyOrder:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"주문수정" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"수거/배달시간",  @"품목", @"가격", @"배정 취소", nil];
    
    [actionSheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self.delegate performSegue:self index:buttonIndex];
    }
    else if (buttonIndex == 1) {
//        [self.delegate performSegue:self index:buttonIndex];
    }
    else if (buttonIndex == 2) {
        [self.delegate performSegue:self index:buttonIndex];
        
    }
    else if (buttonIndex == 3) {
        [self.delegate performSegue:self index:buttonIndex];
    }
}

@end
