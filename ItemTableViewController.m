//
//  ItemTableViewController.m
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 7. 25..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import "ItemTableViewController.h"
#import "ItemDataContoller.h"
#import "Item.h"
#import "ItemCell.h"

@interface ItemTableViewController ()

@property (nonatomic, strong) ItemDataContoller *itemDataController;

@end

@implementation ItemTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.itemDataController = [[ItemDataContoller alloc] init];
    self.itemDataController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemDataController itemCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemDataController itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
    Item *item = [self.itemDataController itemAtIndex:indexPath.row];

    cell.stepper.value = [[item valueForKey:@"count"] integerValue];
    
    cell.nameLabel.text = [item valueForKey:@"name"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@원", [item valueForKey:@"price"]];
    cell.countLabel.text = [NSString stringWithFormat:@"%@", [item valueForKey:@"count"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)dataChange {
    [self.tableView reloadData];    
}

@end
