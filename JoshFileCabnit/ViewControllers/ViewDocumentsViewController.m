//
//  ViewDocumentsViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/25/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "ViewDocumentsViewController.h"
#import "FolderViewController.h"
#import "Defaults.h"
#import "FolderTableViewCell.h"

@interface ViewDocumentsViewController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property NSArray* testFolders;


@end

@implementation ViewDocumentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestPDF" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSDictionary* fileOne = @{@"title": @"Tax form 10B", @"memo": @"dsjkigurehpdsjovtviuyobinjvuboijnlk", @"file": targetURL};
    NSArray* file1 = @[fileOne];
    NSDictionary* folder1 = @{@"title": @"Tax Return", @"files": file1};
    self.testFolders = @[folder1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Defaults getUserDefaultForKey:@"documents"] count];
    //return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FolderTableViewCell* cell = (FolderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ViewDocumentsCellID"];
    if ([[Defaults getUserDefaultForKey:@"atTopLevel"] boolValue])
    {
        NSArray* folder = [Defaults findPlaceInFolders];
        cell.textLabel.text = folder[indexPath.row][@"name"];

    }
    else{
        NSDictionary* folder = [Defaults findPlaceInFolders];
        cell.textLabel.text = folder[@"subfolders"][indexPath.row][@"name"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    FolderViewController* folderVC = segue.destinationViewController;
    folderVC.title = sender.textLabel.text;
    
}






@end