//
//  CheckListViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/25/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "CheckListViewController.h"
#import "CheckListPrototypeCell.h"

@interface CheckListViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray* toDoList;

@end

@implementation CheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoList = [NSMutableArray new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CheckListReuseCellID"];
    cell.textLabel.text = [self.toDoList objectAtIndex:indexPath.row][@"title"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


@end