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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *myBackButton;

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



#pragma mark-- TableView


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if ([[Defaults getUserDefaultForKey:@"atTopLevel"] boolValue])
            {
                self.myBackButton.enabled = NO;
                return [[Defaults getUserDefaultForKey:@"documents"] count];
            }
            else
            {
                NSLog(@"folder");
                self.myBackButton.enabled = YES;
                return [[[Defaults getUserDefaultForKey:@"currentFolder"]objectForKey:@"subfolders"] count];
                
            }
            break;
        
        case 1:
            if ([[Defaults getUserDefaultForKey:@"atTopLevel"] boolValue])
            {
                self.myBackButton.enabled = NO;
                return 0;
            }
            else
            {
                NSLog(@"file");
                NSLog(@"%@", [[Defaults getUserDefaultForKey:@"currentFolder"]objectForKey:@"documents"]);
                self.myBackButton.enabled = YES;
                return [[[Defaults getUserDefaultForKey:@"currentFolder"]objectForKey:@"documents"] count];
                
            }
            break;
            
        default:
            return 1;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FolderTableViewCell* cell = (FolderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ViewDocumentsCellID"];
    if ([[Defaults getUserDefaultForKey:@"atTopLevel"] boolValue])
        {
        NSArray* folder = [Defaults findPlaceInFolders];
        cell.textLabel.text = folder[indexPath.row][@"name"];
        cell.folderID = folder[indexPath.row][@"id"];
    }
    else
    {
        NSDictionary* folder = [Defaults getUserDefaultForKey:@"currentFolder"];
        cell.textLabel.text = folder[@"subfolders"][indexPath.row][@"name"];
        cell.folderID = folder[@"subfolders"][indexPath.row][@"id"];
        //NSLog(@"%@", folder[@"subfolders"]);
        if ([folder[@"subfolders"] count] == 0)
        {
            NSLog(@"no more subFolders");
        }
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = folder[@"subfolders"][indexPath.row][@"name"];
                cell.folderID = folder[@"subfolders"][indexPath.row][@"id"];
                break;
                
            case 1:
                cell.textLabel.text = folder[@"documents"][indexPath.row][@"name"];
                cell.cellFile = folder[@"documents"][indexPath.row];
                break;
                
            default:
                NSLog(@"switch defaulted");
                break;
        }
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Folders";
            break;
            
        case 1:
            return @"Files";
            break;
            
        default:
            return @"No title";
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FolderTableViewCell* cell = (FolderTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSMutableArray* place = (NSMutableArray*)[Defaults getUserDefaultForKey:@"placeInFolders"];
        [place addObject:cell.folderID];
        
        [Defaults setUserDefaults:@[@false,
                                     place]
                          forKeys:@[@"atTopLevel",
                                    @"placeInFolders"]];
        
        [Defaults findPlaceInFolders];
        [self.myTableView reloadData];
    }
    
    else if(indexPath.section == 1)
    {
        FolderTableViewCell* cell = (FolderTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    }

    
}
- (IBAction)didPressBackButton:(id)sender
{
    self.myBackButton.enabled = NO;
    NSMutableArray* place = (NSMutableArray*)[Defaults getUserDefaultForKey:@"placeInFolders"];
    [place removeLastObject];
    if (place.count == 0)
    {
        [Defaults setUserDefaults:@[@true,
                                     place]
                          forKeys:@[@"atTopLevel",
                                    @"placeInFolders"]];
    }
    else
    {
        [Defaults setUserDefaults:@[@false,
                                     place]
                          forKeys:@[@"atTopLevel",
                                    @"placeInFolders"]];
    }
    [Defaults findPlaceInFolders];
    [self.myTableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    FolderViewController* folderVC = segue.destinationViewController;
    folderVC.title = sender.textLabel.text;
    
}






@end