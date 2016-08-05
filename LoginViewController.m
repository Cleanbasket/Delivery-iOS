//
//  RegisterViewController.m
//  CleanBasketDeliver
//
//  Created by Theodore Yongbin Cha on 2015. 7. 15..
//  Copyright (c) 2016년 WashAppKorea. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CBConstants.h"
#import "Keychain.h"


@interface LoginViewController () {
    bool success;
}

@end

@implementation LoginViewController {
    AFHTTPRequestOperationManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_login"]];
    imageview.frame = self.view.frame;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:imageview atIndex:0];
    
    NSAttributedString *userId = [[NSAttributedString alloc] initWithString:@"이메일" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.userIDTextField.attributedPlaceholder = userId;
    
    NSAttributedString *password = [[NSAttributedString alloc] initWithString:@"비밀번호" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.passwordTextField.attributedPlaceholder = password;
    
    // Keychain 등록 정보 가지고 오는 부분.
    if ([self getUserDefault]) {
        [_userIDTextField setText:[self getUserDefault]];
    
        Keychain *keychain = [[Keychain alloc] initWithService:@"CB" withGroup:nil];
        NSData *passwordData = [keychain find:[self getUserDefault]];
        if (passwordData) {
            [_passwordTextField setText:[[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding]];
            [self performSegueWithIdentifier:@"loginToList" sender:self];
//            [[self buttonLogin] sendActionsForControlEvents:UIControlEventTouchUpInside];
            NSLog(@"Keychain is found");
        } else {
            NSLog(@"Keychain data not found");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonLogin:(id)sender {
    
}

- (NSString *)getUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:@"email"];
}
                            
- (void)saveUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:[_userIDTextField text] forKey:@"email"];
    
    Keychain *keychain = [[Keychain alloc]initWithService:@"CB" withGroup:nil];
    NSData *passwordAsValue = [[_passwordTextField text] dataUsingEncoding:NSUTF8StringEncoding];
    if ([keychain insert:[_userIDTextField text] :passwordAsValue]) {
        NSLog(@"data added to keychain: %@ %@", [_userIDTextField text], passwordAsValue);
    }
    else if ([keychain update:[_userIDTextField text] :passwordAsValue]) {
        NSLog(@"failed to add. keychain data updated: %@ %@", [_userIDTextField text], passwordAsValue);
    }
    else {
        NSLog(@"Failed update");
        NSLog(@"%@", [keychain find:[_userIDTextField text]]);
    }
}

- (IBAction)eamilTouchDown:(id)sender {
    
//    [self animateTextField:_userIDTextField up:YES];
    
}

- (IBAction)emailBegin:(id)sender {
    [self animateTextField:_userIDTextField up:YES];
}

- (IBAction)emailEnd:(id)sender {
    [self animateTextField:_userIDTextField up:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


// 로그인 기능

- (BOOL)signIn {
    NSMutableDictionary *parameters =[NSMutableDictionary dictionaryWithDictionary:
                                      @{@"email": [_userIDTextField text],
                                        @"password": [_passwordTextField text],
                                        @"remember": @"true",
                                        @"regid": @"" }];
    
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
                
                [self saveUserDefault];
                
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

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self shouldPerformSegueWithIdentifier:identifier sender:sender]) {
        [super performSegueWithIdentifier:identifier sender:sender];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"loginToList"])
        return [self signIn];
    else
        return true;
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

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
