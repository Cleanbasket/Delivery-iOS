//
//  AssignCell.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 29..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "AssignCell.h"
#import "AFNetworking.h"
#import "CBConstants.h"

@interface AssignCell () {
    AFHTTPRequestOperationManager *afManager;
    NSArray *delivererList;
}

@end

@implementation AssignCell
@synthesize typeLabel, datetimeLabel, orderNumberLabel, addressLabel, contactLabel, priceLabel, itemLabel, memoLabel, noteLabel, dropOffDateLabel;

- (IBAction)assign:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"DELIVERER_LIST"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    [afManager GET:[NSString stringWithFormat:@"%@%@", root, address] parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        delivererList = [NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                        options: NSJSONReadingMutableContainers
                                                          error: nil];
        
        [self showActionSheet];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"배정하기" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSDictionary *deliverer in delivererList) {
        [actionSheet addButtonWithTitle:[deliverer objectForKey:@"name"]];
    }
    
    actionSheet.tag = 0;
    [actionSheet showInView:self];
}

- (IBAction)modifyActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"주문수정" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"수거/배달시간",  @"품목", @"가격", @"배정 취소", nil];
    
    actionSheet.tag = 1;
    [actionSheet showInView:self];
}

- (IBAction)callPhone:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [contactLabel text]]]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) showFinishAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success"
                                                   message:@"처리 성공"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void) showErrorAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"실패"
                                                   message:@"처리 실패"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) return;

        [self assignOrder:buttonIndex];
    }
    else if (actionSheet.tag == 1) {
        [self modifyOrder:buttonIndex];
    }
 }

- (void)assignOrder:(NSInteger)buttonIndex {
    NSDictionary *deliverer = [delivererList objectAtIndex:buttonIndex - 1];
    
    NSArray* array = [[orderNumberLabel text] componentsSeparatedByString: @"-"];
    NSString *oid = [array objectAtIndex:1];
    NSString *uid = [NSString stringWithFormat:@"%@", [deliverer objectForKey:@"uid"]];
    
    NSDictionary *parameters = @{@"oid":oid, @"uid":uid};
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"ASSIGN_PICKUP"];
    
    if (self.tag >= 2) {
        address = [dict objectForKey:@"ASSIGN_DROPOFF"];
        NSLog(@"is Deliver");
    }
    
    afManager = [AFHTTPRequestOperationManager manager];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [afManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *value = responseObject[@"constant"];
        switch ([value integerValue]) {
            case CBServerConstantSuccess:
            {
                [self showFinishAlert];
                [self.delegate finishOrder];
                break;
            }
            case CBServerConstantError:
            {
                [self showErrorAlert];
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlert];
        NSLog(@"%@", [error description]);
    }];
}

- (void)modifyOrder:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.delegate performSegue:self index:buttonIndex];
    }
    else if (buttonIndex == 1) {
//        [self.delegate performSegue:self index:buttonIndex];
    }
    else if (buttonIndex == 1) {
        [self.delegate performSegue:self index:buttonIndex];
    }
    else if (buttonIndex == 2) {
        [self.delegate performSegue:self index:buttonIndex];
    }
}

@end
