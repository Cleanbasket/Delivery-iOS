//
//  LoginViewController.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 2..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CBConstants.h"

@interface LoginViewController () {
    bool success;
}

@end

@implementation LoginViewController {
    AFHTTPRequestOperationManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if ([cookies count] > 0) {
        [self performSegueWithIdentifier:@"loginToList" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonLogin:(id)sender {
    
}

- (BOOL)signIn {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    if ([cookies count] > 0) {
        return true;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                       @"email": [_userIDTextField text], @"password": [_passwordTextField text], @"remember": @"true", @"regid": @"" }];
    
    success = false;
    
    manager = [AFHTTPRequestOperationManager manager];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"LOGIN"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *value = responseObject[@"constant"];
        switch ([value integerValue]) {
            case CBServerConstantSuccess:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                
                success = true;
                dispatch_semaphore_signal(semaphore);
                break;
            }
            // 이메일 주소 없음
            case CBServerConstantEmailError:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self showHudMessage:@"이메일 주소를 다시 확인해주세요."];
                });
                
                success = false;
                dispatch_semaphore_signal(semaphore);
                break;
            }
            // 이메일 주소에 대한 비밀번호 다름
            case CBServerConstantPasswordError:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self showHudMessage:@"비밀번호를 다시 확인해주세요."];
                });
                
                success = false;
                dispatch_semaphore_signal(semaphore);
                break;
            }
            // 정지 계정
            case CBServerConstantAccountDisabled :
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self showHudMessage:@"해당 계정은 사용하실 수 없습니다."];
                });
                
                success = false;
                dispatch_semaphore_signal(semaphore);
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showHudMessage:@"네트워크 연결 상태를 확인해주세요"];
        });
        
        success = false;
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return success;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return [self signIn];
}

- (void)showHudMessage:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud setLabelFont:[UIFont systemFontOfSize:14.0f]];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    
    return;
}

@end
