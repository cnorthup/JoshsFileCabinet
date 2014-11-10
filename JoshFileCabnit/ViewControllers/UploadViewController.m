//
//  UploadViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/25/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "UploadViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FileObject.h"


@interface UploadViewController ()


@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upload];

}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    
}

-(void)upload
{
    NSMutableDictionary* file = [NSMutableDictionary new];
    NSMutableDictionary* document = [NSMutableDictionary new];
    [document setValue:@"newFile" forKey:@"name"];
    //[document setValue:@"75" forKey:@"id"];
    [document setValue:@"memo" forKey:@"memo"];
    [document setValue:@"1" forKey:@"folder_id"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestPDF" ofType:@"pdf"];
    NSURL* url = [NSURL fileURLWithPath:path];
    //[document setObject:[NSData dataWithContentsOfFile:path] forKey:@"file"];
    [document setObject:[NSString stringWithContentsOfFile:path encoding:NSStringEncodingConversionAllowLossy error:nil] forKey:@"file"];
    //[document setObject:[NSString stringWithContentsOfURL:url encoding:NSStringEncodingConversionAllowLossy error:nil] forKey:@"file"];
    
    [file setObject:document forKey:@"document"];
    
    [FileObject createFile:document];
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