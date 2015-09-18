//
//  RegisterViewController.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 15..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "AFNetworking.h"
#import "RegisterViewController.h"
#import "CBConstants.h"

@interface RegisterViewController () {
    AFHTTPRequestOperationManager *afManager;
}

@end

@implementation RegisterViewController

- (IBAction)TakePhoto {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)ChooseExisting {
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:picker2 animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) showDuplicationAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"중복"
                                                   message:@"이메일 중복"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}


- (void) showImageErrorAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"에러"
                                                   message:@"이메일 업로드 실패"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)tryRegister:(id)sender {
    if ([self checkEmpty]) {
        [self register];
    }
    else {
        [self showErrorAlert];
    }
}

- (void)register {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSData *imageData = UIImageJPEGRepresentation(_imageView.image, 0.5);

        NSDictionary *parameters = @{@"email":[_emailLabel text], @"password":[_passwordLabel text], @"name":[_nameLabel text], @"phone":[_phoneLabel text], @"birthday":@""};
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        NSString* root = [dict objectForKey:@"ROOT"];
        NSString* address = [dict objectForKey:@"DELIVERER_JOIN"];

        afManager = [AFHTTPRequestOperationManager manager];
        [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
        afManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [afManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSNumber *value = responseObject[@"constant"];
            switch ([value integerValue]) {
                case CBServerConstantSuccess: {
                    [self showFinishAlert];
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
                }
                case CBServerConstantError: {
                    [self showErrorAlert];
                    break;
                }
                case CBServerConstantsDuplication: {
                    [self showDuplicationAlert];
                    break;
                }
                case CBServerConstantsImageWriteError: {
                    [self showErrorAlert];
                    break;
                }
                default: {
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

- (BOOL)checkEmpty {
    if ([_imageView image] == nil)
        return false;
    if ([_emailLabel.text length] == 0)
        return false;
    if ([_passwordLabel.text length] == 0)
        return false;
    if ([_nameLabel.text length] == 0)
        return false;
    if ([_phoneLabel.text length] == 0)
        return false;
    
    return true;
}

@end
