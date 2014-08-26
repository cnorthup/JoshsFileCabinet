//
//  CheckListViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/25/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "CheckListViewController.h"

@interface CheckListViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation CheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


@end