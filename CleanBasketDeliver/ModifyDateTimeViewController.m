//
//  ModifyDateTimeViewController.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 20..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "AFNetworking.h"
#import "ModifyDateTimeViewController.h"
#import "CBConstants.h"

@interface ModifyDateTimeViewController () {
    AFHTTPRequestOperationManager *afManager;
}

@end

@implementation ModifyDateTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setDateTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOrder:(NSDictionary *)receivedOrder {
    orderData = receivedOrder;
}

- (void)setDateTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    
    [self.pickupDatePicker setDate:[dateFormatter dateFromString:[orderData valueForKey:@"pickup_date"]]];
    [self.dropoffDatePicker setDate:[dateFormatter dateFromString:[orderData valueForKey:@"dropoff_date"]]];
}

- (IBAction)cancleEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonModify:(id)sender {
    NSDate *pickerDate = [_pickupDatePicker date];
    NSDate *dropoffDate = [_dropoffDatePicker date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];

    [orderData setValue:[dateFormatter stringFromDate:pickerDate] forKey:@"pickup_date"];
    [orderData setValue:[dateFormatter stringFromDate:dropoffDate] forKey:@"dropoff_date"];
    
    [self sendOrder:orderData];
}

- (void)sendOrder:(NSDictionary *)order {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"ORDER_MODIFY_TIME"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [afManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:order success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *value = responseObject[@"constant"];
        switch ([value integerValue]) {
            case CBServerConstantSuccess: {
                [self showFinishAlert];
                break;
            }
            case CBServerConstantError: {
                [self showErrorAlert];
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlert];
        NSLog(@"%@", [error description]);
    }];
}

- (void)showFinishAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success"
                                                   message:@"처리 성공"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)showErrorAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"실패"
                                                   message:@"처리 실패"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
