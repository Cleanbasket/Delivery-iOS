//
//  ExpandingCell.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 4..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "ExpandingCell.h"
#import "AFNetworking.h"
#import "CBConstants.h"

@interface ExpandingCell () {
    AFHTTPRequestOperationManager *afManager;
}

@end

@implementation ExpandingCell
@synthesize typeLabel, datetimeLabel, orderNumberLabel, addressLabel, contactLabel, priceLabel, itemLabel, memoLabel;

- (IBAction)buttonFinish:(id)sender {
    [self showConfirmationAlert];
}

- (void) showConfirmationAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Question"
                                                   message:@"확실합니까?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSArray* array = [[orderNumberLabel text] componentsSeparatedByString: @"-"];
    NSString *oid = [array objectAtIndex: 1];

    if (buttonIndex == 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSDictionary *parameters = @{@"oid":oid, @"note":@""};
            
            NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
            NSString* root = [dict objectForKey:@"ROOT"];
            NSString* address = [dict objectForKey:@"CONFIRM_PICKUP"];

            if (self.tag > 2) {
                address = [dict objectForKey:@"CONFIRM_DROPOFF"];
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
        });
    }
}

- (IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [contactLabel text]]]];
    NSLog(@"Phone Call");
}

@end
