//
//  UploadViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/25/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()


@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    
}

- (IBAction)onSelectFromLibaryPressed:(id)sender
{
    
    [self showDocumentPickerInMode:UIDocumentPickerModeOpen];
    
//    UIDocumentPickerViewController* picker = [[UIDocumentPickerViewController alloc] init];
//    picker.delegate = self;
//    picker.modalPresentationStyle = YES;
//    [self presentViewController:picker animated:YES completion:nil];
//    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)showDocumentPickerInMode:(UIDocumentPickerMode)mode {
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.text"] inMode:mode];
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (IBAction)onSelectPhotoButtonPressed:(id)sender
{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

@end