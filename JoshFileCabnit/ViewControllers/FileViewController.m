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
    self.fileNameTextField.text = self.myFile.fileName;
    self.folderNameTextField.text = self.myFile.folderName;
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    NSLog(@"%f",screenRect.size.height);
    NSLog(@"%f", self.memoTextView.frame.size.height);
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

#pragma mark-- FileObject

-(void)dataFetchComplete:(FileObject*)object
{
    self.myFile = object;
    [self.myFile getFileFromFileObject:self.myFile];
}

-(void)dataFetchFailed
{
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"ConnectionFailed" message:@"We are sorry but we could not retrieve the file you are looking for" delegate:self cancelButtonTitle:@"Go back" otherButtonTitles:@"Retry", nil];
//    [alertView show];
}

-(void)fileDataRecieved:(id)file
{
    [self showFile:file];
}

-(void)fileDataRecieveError
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
        [self.myFile getFileData:self.myFile];
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
            [self.myFile getFileFromFileObject:self.myFile];
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

-(void)showFile:(NSString*)filePath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestPDF" ofType:@"pdf"];
    NSLog(@"the test path is %@", path);
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];
    UIDocumentInteractionController* docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
    docController.delegate = self;
    [docController presentPreviewAnimated:YES];
}


@end
