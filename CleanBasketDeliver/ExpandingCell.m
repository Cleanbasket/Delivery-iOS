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
#import "RegisterViewController.h"

@interface ExpandingCell () {
    AFHTTPRequestOperationManager *afManager;
}

@end

@implementation ExpandingCell
@synthesize typeLabel, datetimeLabel, orderNumberLabel, addressLabel, contactLabel, priceLabel, itemLabel, memoLabel, noteLabel;

- (IBAction)buttonFinish:(id)sender {
    if (self.tag > 2) {
        [self showDropOffConfirmationAlert];
    } else {
        [self showPickUpConfirmationAlert];
        
    }
}


- (void) showDropOffConfirmationAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Question"
                                                   message:@"결제 금액과 결제 수단을 선택해주세요."
                                                  delegate:self
                                         cancelButtonTitle:@"취소"
                                         otherButtonTitles:@"현장 카드 결제", @"계좌이체", @"인앱 결제", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    //    UITextField *alertTextField = [alert textFieldAtIndex:0];
    //    alertTextField.placeholder = @"특이사항이 있으면 남겨주세요";
    
    [[alert textFieldAtIndex:1] setSecureTextEntry:NO];
    [alert textFieldAtIndex:1].keyboardType = UIKeyboardTypePhonePad;
    [[alert textFieldAtIndex:0] setPlaceholder:@"특이사항이 있으면 남겨주세요"];
    [[alert textFieldAtIndex:1] setPlaceholder:@"결제 금액을 입력해주세요."];
    
    
    [alert show];
}

- (void) showPickUpConfirmationAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Question"
                                                   message:@"완료하시겠습니까? 특이 사항을 입력하세요."
                                                  delegate:self
                                         cancelButtonTitle:@"취소"
                                         otherButtonTitles:@"확인", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"특이사항이 있으면 남겨주세요";
    [alert show];
}

- (void) showFinishAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success"
                                                   message:@"처리 성공"
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void) showErrorAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"실패"
                                                   message:@"처리 실패"
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void) showErrorMessageAlert:(NSString *) msg {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"실패"
                                                   message:msg
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void) sendPickupConfirmData:(NSDictionary *) parameters{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        NSString* root = [dict objectForKey:@"ROOT"];
        NSString* address = [dict objectForKey:@"CONFIRM_PICKUP"];
        
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
                    [self showErrorMessageAlert:responseObject[@"message"]];
                    break;
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorMessageAlert:[error description]];
            NSLog(@"%@", [error description]);
        }];
    });
}

- (void) sendDropoffConfirmData:(NSDictionary *) parameters{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        NSString* root = [dict objectForKey:@"ROOT"];
        NSString* address = [dict objectForKey:@"CONFIRM_DROPOFF"];
        
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
                    [self showErrorMessageAlert:responseObject[@"message"]];
                    break;
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            
            
            [self showErrorMessageAlert:ErrorResponse];
            
            NSLog(@"%@", ErrorResponse);
        }];
    });
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSArray* array = [[orderNumberLabel text] componentsSeparatedByString: @"-"];
    NSString *oid = [array objectAtIndex:1];
    
    
    NSDictionary *parameters = @{@"oid":oid, @"price":[[alertView textFieldAtIndex:1] text], @"note":[[alertView textFieldAtIndex:0] text], @"payment_method":[NSString stringWithFormat:@"%ld", (long) (buttonIndex)]};
    
    
    
    if (buttonIndex > 0 && self.tag > 2) {
        NSLog(@"dropoff");
        
        NSLog(@"Button indext is %ld", (long) buttonIndex);
        
        
        if([[[alertView textFieldAtIndex:1] text] isEqualToString:@""]){
            [self showErrorMessageAlert:@"결제 금액을 반드시 입력해주세요."];
            return;
        }
        
        [self sendDropoffConfirmData:parameters];
        
    }else if (buttonIndex > 0){
        NSLog(@"pickup");
        [self sendPickupConfirmData:parameters];
    }
}

- (IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [contactLabel text]]]];
}

@end
