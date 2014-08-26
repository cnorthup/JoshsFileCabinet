//
//  ViewDocumentsViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/25/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "ViewDocumentsViewController.h"
#import "FolderViewController.h"


@interface ViewDocumentsViewController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end

@implementation ViewDocumentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestPDF" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.myWebView loadRequest:request];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ViewDocumentsCellID"];
    if (indexPath.row == 0) {
    cell.textLabel.text = @"Tax Return";
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"Bank info";

    }
    else
    {
        cell.textLabel.text = @"Assests";

    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    FolderViewController* folderVC = segue.destinationViewController;
    folderVC.title = sender.textLabel.text;
    
}



//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    if (self.myWebView.canGoBack == YES) {
//        self.isBackButtonAbleToWork.enabled = YES;
//
//    } else if (self.myWebView.canGoBack == NO){
//        self.isBackButtonAbleToWork.enabled = NO;
//    }
//    
//    if (self.myWebView.canGoForward == YES) {
//        self.isForwardButtonAbleToWork.enabled = YES;
//        
//    } else if (self.myWebView.canGoForward == NO){
//        self.isForwardButtonAbleToWork.enabled = NO;
//    }
//    self.isStopButtonAbleToWork.enabled = NO;
//    self.isReloadButtonAbleToWork.enabled = YES;
//}



@end