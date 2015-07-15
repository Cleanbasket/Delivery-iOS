//
//  ThirdViewController.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 13..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "ThirdViewController.h"
#import "ExpandingCell.h"
#import "AFNetworking.h"
#import "order.h"

@interface ThirdViewController () {
    AFHTTPRequestOperationManager *afManager;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ThirdViewController
@synthesize dataDropOffArray, buttonFinish;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"FirstViewController" bundle:nil];
    
    if (self) {
        self.title = NSLocalizedString(@"수거", @"수거");
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    selectedIndex = -1;
    
    [self getData];
}

- (void)getData {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Address" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString* root = [dict objectForKey:@"ROOT"];
    NSString* address = [dict objectForKey:@"DELIVERER_DROPOFF"];
    
    afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [afManager setRequestSerializer:[AFHTTPRequestSerializer new]];
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
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *order = [dataDropOffArray objectAtIndex:indexPath.row];
    NSInteger state = [[order objectForKey:@"state"] integerValue];
    
    // Later
    if (selectedIndex == indexPath.row) {
        cell.contentView.backgroundColor = [UIColor darkGrayColor];
        cell.typeLabel.textColor = [UIColor whiteColor];
        cell.datetimeLabel.textColor = [UIColor whiteColor];
        cell.orderNumberLabel.textColor = [UIColor whiteColor];
        cell.addressLabel.textColor = [UIColor whiteColor];
        cell.contactLabel.textColor = [UIColor whiteColor];
        cell.priceLabel.textColor = [UIColor whiteColor];
        cell.itemLabel.textColor = [UIColor whiteColor];
        cell.memoLabel.textColor = [UIColor whiteColor];
    }
    else {
        if (state == 2 || state == 4)
            cell.contentView.backgroundColor = [UIColor lightGrayColor];
        else
            cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.typeLabel.textColor = [UIColor purpleColor];
        cell.datetimeLabel.textColor = [UIColor blackColor];
        cell.orderNumberLabel.textColor = [UIColor blackColor];
        cell.addressLabel.textColor = [UIColor blackColor];
        cell.contactLabel.textColor = [UIColor blackColor];
        cell.priceLabel.textColor = [UIColor blackColor];
        cell.itemLabel.textColor = [UIColor blackColor];
        cell.memoLabel.textColor = [UIColor blackColor];
    }
    
    if (state < 3)
        cell.typeLabel.text = @"수거";
    else
        cell.typeLabel.text = @"배달";
    
    NSString *price = [NSString stringWithFormat:@"%@", [order objectForKey:@"price"]];
    
    NSString *address = [order objectForKey:@"address"];
    NSString *addr_building = [order objectForKey:@"addr_building"];
    NSString *addr_number = [order objectForKey:@"addr_number"];
    NSString *addr_remainder =[order objectForKey:@"addr_remainder"];
    
    NSRange needleRange = NSMakeRange(0, 16);
    NSString *datetime = [[order objectForKey:@"dropoff_date"] substringWithRange:needleRange];
    
    cell.datetimeLabel.text = datetime;
    cell.orderNumberLabel.text = [order objectForKey:@"order_number"];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", address, addr_building, addr_number, addr_remainder];
    cell.contactLabel.text = [order objectForKey:@"phone"];
    cell.priceLabel.text = price;
    cell.memoLabel.text = [order objectForKey:@"memo"];
    
    cell.tag = state;
    
    cell.clipsToBounds = YES;
    
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndex == indexPath.row) {
        return 190;
    } else {
        return 44;
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
    
    [buttonFinish addTarget:self action:@selector(buttonFinishPressed) forControlEvents:UIControlEventTouchDown];
}

-(void)finishOrder {
    selectedIndex = -1;
    
    [self getData];
}

@end
