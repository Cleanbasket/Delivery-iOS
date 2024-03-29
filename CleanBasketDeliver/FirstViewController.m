//
//  FirstViewController.m
//  CleanBasketDeliver
//
//  Created by Theodore Yongbin Cha on 2015. 7. 15..
//  Copyright (c) 2016년 WashAppKorea. All rights reserved.
//

#import "FirstViewController.h"
#import "ExpandingCell.h"
#import "AFNetworking.h"
#import "order.h"
#import "MBProgressHUD.h"

@interface FirstViewController () {
    AFHTTPRequestOperationManager *afManager;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FirstViewController
@synthesize dataArray, dataRawArray,buttonFinish;

- (void)viewWillAppear:(BOOL)animated {
    selectedIndex = -1;
    
    [self getData];
}

- (void)getData {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"DELIVERER_PICKUP"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dataRawArray = [NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                          options: NSJSONReadingMutableContainers
                                                            error: nil];
        [self getDeliverData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)getDeliverData {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"DELIVERER_DROPOFF"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
    [afManager POST:[NSString stringWithFormat:@"%@%@", root, address] parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [dataRawArray addObjectsFromArray:[NSJSONSerialization JSONObjectWithData: [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil]];
        [self sortData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)sortData {
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *order in dataRawArray) {
        Order *newOrder = [[Order alloc] initWithDictionary:order];

        [dataArray addObject:newOrder];
    }
    
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"order_date" ascending:YES];
    [dataArray sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.49 green:0.75 blue:0.78 alpha:1.0]];
    
    //Set index to -1 saying no cell is expanded or should expand.
    selectedIndex = -1;
}

- (IBAction)reload:(id)sender {
    [self getData];
    [self showHudMessage:@"로딩중입니다."];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Order *order = [dataArray objectAtIndex:indexPath.row];
    NSInteger state = (int) [order state];
    
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
        cell.noteLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.couponLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        cell.mileageLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
    }
    else {
        if (state == 2 || state == 4){
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
            cell.noteLabel.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
        }
    }
    
    if (state < 3)
        cell.typeLabel.text = @"수거";
    else
        cell.typeLabel.text = @"배달";
    
    NSString *price;
    if ([order payment_method] == 3) {
        price = [NSString stringWithFormat:@"인앱 %d", (int) [order price]];
    } else {
        price = [NSString stringWithFormat:@"%d", (int) [order price]];
    }
    
    NSString *address = [order address];
    NSString *addr_building = [order addr_building];
    NSString *addr_number = [order addr_number];
    NSString *addr_remainder =[order addr_remainder];
    
    NSRange needleRange = NSMakeRange(0, 16);
    
    NSString *datetime;
    if (state < 3) datetime = [[order pickup_date] substringWithRange:needleRange];
    else datetime = [[order dropoff_date] substringWithRange:needleRange];
    
    NSArray<Item> *items = [order item];
    
    cell.datetimeLabel.text = datetime;
    cell.orderNumberLabel.text = [order order_number];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", address, addr_number, addr_building, addr_remainder];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *afterDate = [dateFormat dateFromString:datetime];
    
    NSDate* now = [NSDate date];
    
    NSTimeInterval diff = [now timeIntervalSinceDate:afterDate];
    
    if (diff > -1800){
        cell.contactLabel.text = [order phone];
    } else {
        NSNumber *myDoubleNumber = [NSNumber numberWithDouble:diff];
        cell.contactLabel.text = @"30분 전에 확인 가능합니다.";
    }
    cell.priceLabel.text = price;
    cell.itemLabel.text = [self getItemList:items];
    cell.memoLabel.text = [order memo];
    cell.noteLabel.text = [order note];
    cell.couponLabel.text = [self getCouponList:[order coupon]];
    cell.mileageLabel.text = [NSString stringWithFormat:@"마일리지 %d", (int) [order mileage]];
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
        return 230;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // User taps expanded row
    if (selectedIndex == indexPath.row) {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    // User taps different row
    if (selectedIndex != -1) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSMutableArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // User taps new row with none expanded
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)finishOrder {
    selectedIndex = -1;
    
    [self getData];
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
