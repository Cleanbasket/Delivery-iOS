//
//  ThirdViewController.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 13..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "ThirdViewController.h"
#import "ModifyDateTimeViewController.h"
#import "AssignCell.h"
#import "AFNetworking.h"
#import "order.h"

@interface ThirdViewController () {
    AFHTTPRequestOperationManager *afManager;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ThirdViewController
@synthesize dataDropOffArray, buttonFinish;

- (void)viewWillAppear:(BOOL)animated {
    selectedIndex = -1;
    
    [self getData];
}

- (void)getData {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"ORDER_DROPOFF"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [afManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dataDropOffArray = [NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                          options: NSJSONReadingMutableContainers
                                                            error: nil];
        [self.tableView reloadData];
        NSLog(@"Second Success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Set index to -1 saying no cell is expanded or should expand.
    selectedIndex = -1;
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataDropOffArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"assignCell";
    AssignCell *cell = (AssignCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssignCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *order = [dataDropOffArray objectAtIndex:indexPath.row];
    NSInteger state = [[order objectForKey:@"state"] integerValue];
    
    // Later
    if (selectedIndex == indexPath.row) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.typeLabel.textColor = [UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0];
        cell.datetimeLabel.textColor = [UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0];
        cell.orderNumberLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.addressLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.contactLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.priceLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.itemLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.memoLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.couponLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.mileageLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.dropOffDateLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.noteLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
    }
    else {
        if (state == 1 || state == 3){
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
            cell.typeLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.datetimeLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.orderNumberLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.addressLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.contactLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.priceLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.itemLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.memoLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.couponLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.mileageLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.dropOffDateLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.noteLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
        }
        else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.typeLabel.textColor = [UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0];
            cell.datetimeLabel.textColor = [UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0];
            cell.orderNumberLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.addressLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.contactLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.priceLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.itemLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.memoLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.couponLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.mileageLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.dropOffDateLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
            cell.noteLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        }
    }
    
    DropoffInfo *dropoffInfo = [order objectForKey:@"dropoffInfo"];
    
    if (state == 2)
        cell.typeLabel.text = @"미배정";
    else if (state == 3)
        cell.typeLabel.text = [dropoffInfo valueForKey:@"name"];
    
    NSString *price;
    if ([[order objectForKey:@"payment_method"] integerValue] == 3) {
        price = [NSString stringWithFormat:@"인앱 %@", [order objectForKey:@"price"]];
    } else {
        price = [NSString stringWithFormat:@"%@", [order objectForKey:@"price"]];
    }
    
    NSString *address = [order objectForKey:@"address"];
    NSString *addr_building = [order objectForKey:@"addr_building"];
    NSString *addr_number = [order objectForKey:@"addr_number"];
    NSString *addr_remainder =[order objectForKey:@"addr_remainder"];

    NSArray<Item> *items = [[dataDropOffArray objectAtIndex:indexPath.row] objectForKey:@"item"];

    NSRange needleRange = NSMakeRange(0, 16);
    NSString *datetime = [[order objectForKey:@"dropoff_date"] substringWithRange:needleRange];
    NSArray<Coupon> *coupons = [[dataDropOffArray objectAtIndex:indexPath.row] objectForKey:@"coupon"];

    cell.datetimeLabel.text = datetime;
    cell.orderNumberLabel.text = [order objectForKey:@"order_number"];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", address, addr_building, addr_number, addr_remainder];
    cell.contactLabel.text = [order objectForKey:@"phone"];
    cell.priceLabel.text = price;
    cell.memoLabel.text = [order objectForKey:@"memo"];
    cell.itemLabel.text = [self getItemList:items];
    cell.noteLabel.text = [order objectForKey:@"note"];
    cell.couponLabel.text = [self getCouponList:coupons];
    cell.mileageLabel.text = [NSString stringWithFormat:@"마일리지 %@", [order objectForKey:@"mileage"]];
    cell.dropOffDateLabel.text = [[order objectForKey:@"pickup_date"] substringWithRange:needleRange];

    cell.tag = state;
    
    cell.clipsToBounds = YES;
    
    cell.delegate = self;
    
    return cell;
}

- (NSString *)getItemList:(NSArray<Item> *)items {
    NSString *result = [NSString new];
    
    for (Item *item in items) {
        NSString *itemName = [item valueForKey:@"name"];
        NSString *itemQuantity = [NSString stringWithFormat:@"%@", [item valueForKey:@"count"]];
        NSString *nameAndQuantity = [NSString stringWithFormat:@"%@(%@) ", itemName, itemQuantity];
        result = [result stringByAppendingString:nameAndQuantity];
    }
    
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndex == indexPath.row) {
        return 260;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // User taps expanded row
    if (selectedIndex == indexPath.row) {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    // User taps different row
    if (selectedIndex != -1) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // User taps new row with none expanded
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)finishOrder {
    selectedIndex = -1;
    
    [self getData];
}

- (void)performSegue:(id)sender index:(NSInteger)index {
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"modifyDateTimeB" sender:sender];
            break;
        case 1:
            [self performSegueWithIdentifier:@"modifyItemB" sender:sender];
            break;
        case 2:
            [self modifyTotal];
            break;
        case 3:
            [self cancelAssign];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"modifyDateTimeB"]) {
        [segue.destinationViewController setOrder:[dataDropOffArray objectAtIndex:selectedIndex]];
    }
}

- (void)modifyTotal {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Question"
                                                   message:@"가격 변경"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"변경된 가격을 정확히 입력";
    
    [alert show];
}

- (void)cancelAssign {
    NSMutableDictionary *order = [dataDropOffArray objectAtIndex:selectedIndex];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"ASSIGN_CANCEL"];
    
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
                
                [self getData];
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
    if (buttonIndex == 1) {
        NSInteger price = [[[alertView textFieldAtIndex:0] text] integerValue];
        
        NSMutableDictionary *order = [dataDropOffArray objectAtIndex:selectedIndex];
        [order removeObjectForKey:@"price"];
        [order setObject:[NSNumber numberWithLong:price] forKey:@"price"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        NSString* root = [dict objectForKey:@"ROOT"];
        NSString* address = [dict objectForKey:@"ORDER_MODIFY_TOTAL"];
        
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
                    
                    [_tableView reloadData];
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
}

- (NSString *)getCouponList:(NSArray<Coupon> *)coupons {
    NSString *result = [NSString new];
    
    for (Item *item in coupons) {
        NSString *couponName = [item valueForKey:@"name"];
        NSString *value = [NSString stringWithFormat:@"%@", [item valueForKey:@"value"]];
        NSString *nameAndQuantity = [NSString stringWithFormat:@"%@(%@) ", couponName, value];
        result = [result stringByAppendingString:nameAndQuantity];
    }
    
    return result;
}

@end
