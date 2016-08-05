//
//  OrderViewController.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 17..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "OrderViewController.h"
#import "ModifyDateTimeViewController.h"
#import "OrderCell.h"
#import "AFNetworking.h"
#import "order.h"



@interface OrderViewController () {
    AFHTTPRequestOperationManager *afManager;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderViewController
@synthesize dataArray;

- (void)viewWillAppear:(BOOL)animated {
    selectedIndex = -1;
    
    [self getData];
}

- (void)getData {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"DELIVERER_ORDER"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [afManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:@{@"oid":@"0"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dataArray = [NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
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
    self.searchBarView.delegate = self;
    self.searchBarView.showsSearchResultsButton = YES;
    
    //Set index to -1 saying no cell is expanded or should expand.
    selectedIndex = -1;
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"orderCell";
    OrderCell *cell = (OrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *order = [dataArray objectAtIndex:indexPath.row];
    NSInteger state = [[order objectForKey:@"state"] integerValue];
    
    // Later
    if (selectedIndex == indexPath.row) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.pickUpLabel.textColor = [UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0];
        cell.dropOffLabel.textColor = [UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0];
        cell.orderNumberLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.addressLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.contactLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.priceLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.itemLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.memoLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.couponLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.mileageLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.stateLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.noteLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
    }
    else {
        if (state == 1 || state == 3){
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
            cell.pickUpLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.dropOffLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.orderNumberLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.addressLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.contactLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.priceLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.itemLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.memoLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.couponLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.mileageLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.stateLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.noteLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
        }
        else if (state == 4){
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
            cell.pickUpLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.dropOffLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.orderNumberLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.addressLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.contactLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.priceLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.itemLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.memoLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.couponLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.mileageLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.stateLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
            cell.noteLabel.textColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
        }
        else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.pickUpLabel.textColor = [UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0];
        cell.dropOffLabel.textColor = [UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0];
        cell.orderNumberLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.addressLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.contactLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.priceLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.itemLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.memoLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.couponLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.mileageLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.stateLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.noteLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        }
    }
      
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

    NSArray<Item> *items = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"item"];
    NSArray<Coupon> *coupons = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"coupon"];

    NSRange needleRange = NSMakeRange(0, 16);
    NSString *pickUpDate = [[order objectForKey:@"pickup_date"] substringWithRange:needleRange];
    NSString *dropOffDate = [[order objectForKey:@"dropoff_date"] substringWithRange:needleRange];
    
    cell.pickUpLabel.text = pickUpDate;
    cell.dropOffLabel.text = dropOffDate;
    cell.orderNumberLabel.text = [order objectForKey:@"order_number"];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", address, addr_building, addr_number, addr_remainder];
    cell.contactLabel.text = [order objectForKey:@"phone"];
    cell.priceLabel.text = price;
    cell.memoLabel.text = [order objectForKey:@"memo"];
    cell.itemLabel.text = [self getItemList:items];
    cell.couponLabel.text = [self getCouponList:coupons];
    cell.mileageLabel.text = [NSString stringWithFormat:@"마일리지 %@", [order objectForKey:@"mileage"]];
    cell.stateLabel.text = [self getState:order];
    cell.noteLabel.text = [order objectForKey:@"note"];

    cell.clipsToBounds = YES;
    
    cell.delegate = self;
    
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
}

- (NSString *)getState:(NSDictionary *)order {
    NSInteger state = [[order objectForKey:@"state"] integerValue];
    PickupInfo *pickupInfo = [order objectForKey:@"pickupInfo"];
    DropoffInfo *dropoffInfo = [order objectForKey:@"dropoffInfo"];
    
    NSString *name = @"PD";
    NSString *result = @"";
    
    switch (state) {
        case 0:
            result = @"수거대기";
            break;
        case 1:
            name = [pickupInfo valueForKey:@"name"];
            result = @"수거배정";
            break;
        case 2:
            result = @"배달대기";
            break;
        case 3:
            name = [dropoffInfo valueForKey:@"name"];
            result = @"배달배정";
            break;
        case 4:
            name = [dropoffInfo valueForKey:@"name"];
            result = @"배달완료";
            break;
    }
    
    return [NSString stringWithFormat:@"%@(%@)", result, name];
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
    NSMutableDictionary *order = [dataArray objectAtIndex:selectedIndex];
    
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSInteger price = [[[alertView textFieldAtIndex:0] text] integerValue];
        
        NSMutableDictionary *order = [dataArray objectAtIndex:selectedIndex];
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

- (void)performSegue:(id)sender index:(NSInteger)index {
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"modifyDateTime" sender:sender];
            break;
        case 1:
            [self performSegueWithIdentifier:@"modifyItem" sender:sender];
            break;
        case 2:
            [self modifyTotal];
            break;
        case 3:
            [self cancelAssign];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"modifyDateTime"]) {
        [segue.destinationViewController setOrder:[dataArray objectAtIndex:selectedIndex]];
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

//- (void)tableView:(UITableView *)tableView
//  willDisplayCell:(UITableViewCell *)cell
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self getMoreData];
//}

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
        return 230;
    } else {
        return 65;
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

- (void)getMoreData {
    NSDictionary *order = [dataArray objectAtIndex:dataArray.count - 1];
    NSString *oid = [NSString stringWithFormat:@"%@", [order objectForKey:@"oid"]];

    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"DELIVERER_ORDER"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [afManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:@{@"oid":oid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [dataArray addObjectsFromArray:[NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                    options: NSJSONReadingMutableContainers
                                                      error: nil]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tableView endEditing:YES];
}

- (IBAction)loadOrder:(id)sender {
    [self getMoreData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length <= 5)
        [self getOrderByOid:searchBar.text];
    else if (searchText.length == 11)
        [self getOrderByPhone:searchBar.text];
    else if (searchText.length == 0)
        [self getData];
}

- (void)getOrderByOid:(NSString *)oid {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"DELIVERER_ORDER"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [afManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [afManager GET:[NSString stringWithFormat:@"%@%@/%@", root, address, oid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *value = responseObject[@"constant"];

        NSMutableArray *orders;
        switch ([value integerValue]) {
            case CBServerConstantSuccess:
                orders = [NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: nil];

                [dataArray removeAllObjects];
                [dataArray addObject:orders];
                
                [self.tableView reloadData];
                break;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)getOrderByPhone:(NSString *)phone {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"DELIVERER_ORDER_PHONE"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    afManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [afManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:@{@"phone":phone} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *value = responseObject[@"constant"];
        
        switch ([value integerValue]) {
            case CBServerConstantSuccess:
                [dataArray removeAllObjects];
                dataArray = [NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
                
                [self.tableView reloadData];
                break;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
