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
#import "Defaults.h"


@interface UploadViewController ()


@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[UploadViewController upload];

}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    
}

+(void)upload
{
    NSLog(@"uploading");
    NSMutableDictionary* file = [NSMutableDictionary new];
    NSMutableDictionary* document = [NSMutableDictionary new];
    [document setValue:@"James" forKey:@"name"];
    [document setValue:@"memo" forKey:@"memo"];
    [document setValue:@"1" forKey:@"folder_id"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestPDF" ofType:@"pdf"];
    
    UIImage* image = [UIImage imageNamed:@"bear"];
    NSData *picData = UIImageJPEGRepresentation(image, 1.0);
    NSString* base64 = [picData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    [document setObject:base64 forKey:@"file"];
    [file setObject:document forKey:@"document"];
    //NSLog(@"%@", file);

    [FileObject createFile:file];
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