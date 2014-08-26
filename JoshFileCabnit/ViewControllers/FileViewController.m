//
//  FileViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/26/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "FileViewController.h"


@interface FileViewController () <UIWebViewDelegate, UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;


@end

@implementation FileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (IBAction)pressedSegementedController:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self showFile];
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        default:
            break;
    }
}

-(void)showFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestPDF" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    UIDocumentInteractionController* docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
    docController.delegate = self;
    [docController presentPreviewAnimated:YES];
}


@end
