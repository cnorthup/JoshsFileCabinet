//
//  FolderViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/26/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "FolderViewController.h"
#import "ViewDocumentsViewController.h"
#import "FileViewController.h"


@interface FolderViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FolderReuseCellID"];
    cell.textLabel.text = @"Taxes 2008";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    FileViewController* fileVC = segue.destinationViewController;
    fileVC.title = sender.textLabel.text;
}



@end