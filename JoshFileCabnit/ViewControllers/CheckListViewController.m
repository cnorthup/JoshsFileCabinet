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
@property NSIndexPath* selectedRowIndex;
@property CheckListPrototypeCell* selectedCell;

@end

@implementation CheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoList = [NSMutableArray new];
    NSDictionary* sample = @{@"title": @"Go to meeting", @"instructions": @"Fly to mars, build civilations. Come back and then making a flying machine that is man powered and works.  Then go to the Sears Tower floor 38, room 5 for the meeting next thursday at 10 am.", @"completed" : @(NO)};
    [self.toDoList addObject:sample];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckListPrototypeCell* cell = (CheckListPrototypeCell*)[tableView dequeueReusableCellWithIdentifier:@"CheckListReuseCellID"];
    cell.cellTitle.text = [self.toDoList objectAtIndex:indexPath.row][@"title"];
    cell.instructionsTextView.text = [self.toDoList objectAtIndex:indexPath.row][@"instructions"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowIndex = indexPath;
    self.selectedCell = (CheckListPrototypeCell*)[tableView cellForRowAtIndexPath:indexPath];
    [tableView beginUpdates];
    [tableView endUpdates];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row) {
        NSLog(@"%f",self.selectedCell.instructionsTextView.contentSize.height);
        float newHeight = self.selectedCell.instructionsTextView.contentSize.height + 52.5;
        NSLog(@"%f", newHeight);
        return newHeight;
    }
    return 44;
}


@end