//
//  FileViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/26/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "FileViewController.h"
#import "FileObject.h"


@interface FileViewController () <UIWebViewDelegate, UIDocumentInteractionControllerDelegate, UITextFieldDelegate, FileObjectDelegate, UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UITextField *folderNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementedController;


@end

@implementation FileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.saveButton.hidden = YES;
    self.memoTextView.editable = NO;
    self.fileNameTextField.enabled = NO;
    self.folderNameTextField.enabled = NO;
    self.myFile.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.myFile getFile:self.myFile];

    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    NSLog(@"%f",screenRect.size.height);
    if (screenRect.size.height == 548)
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 479);
        self.memoTextView.frame = CGRectMake(self.memoTextView.frame.origin.x, self.memoTextView.frame.origin.y, self.memoTextView.frame.size.width, 257+88);
    }
    else
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 391);
        //self.memoTextView.frame = CGRectMake(self.memoTextView.frame.origin.x, self.memoTextView.frame.origin.y, self.memoTextView.frame.size.width, 257-69);
    }
    [self.myFile getFile:self.myFile];
    NSLog(@"%f", self.memoTextView.frame.size.height);
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

#pragma mark-- FileObject

-(void)dataFetchComplete:(NSDictionary*)object
{
    NSLog(@"%@", object);
}

-(void)dataFetchFailed
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"ConnectionFailed" message:@"We are sorry but we could not retrieve the file you are looking for" delegate:self cancelButtonTitle:@"Go back" otherButtonTitles:@"Retry", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.myFile getFile:self.myFile];
    }
}

- (IBAction)pressedSegementedController:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.saveButton.hidden = YES;
            self.memoTextView.editable = NO;
            self.fileNameTextField.enabled = NO;
            self.folderNameTextField.enabled = NO;
            break;
            
        case 1:
            self.saveButton.hidden = NO;
            self.memoTextView.editable = YES;
            self.fileNameTextField.enabled = YES;
            self.folderNameTextField.enabled = YES;
            break;
            
        case 2:
            [self showFile];
            self.saveButton.hidden = YES;
            self.memoTextView.editable = NO;
            self.fileNameTextField.enabled = NO;
            self.folderNameTextField.enabled = NO;
            break;
            
        default:
            break;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.folderNameTextField)
    {
        
    }
    else if (textField == self.fileNameTextField)
    {
        
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
