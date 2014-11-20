//
//  FileObject.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 9/27/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "FileObject.h"
#import "Defaults.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface FileObject ()

@property NSString* fileID;
@property NSDictionary* unparsedFile;
@property BOOL filledOut;
@property NSData* fileData;
@property NSURL* fileUrl;
@property NSURL* thumbnailUrl;
@property NSDate*  created;
@property id file;


@end

@implementation FileObject

-(void) succeedInGettingData
{
    NSLog(@"protocal worked, got that data");
    //[self.delegate dataFetchComplete:nil];
}

+(FileObject*)initWithFile:(NSDictionary*)file
{
    FileObject* myFile = [FileObject new];
    myFile.fileName = file[@"name"];
    myFile.fileID = file[@"id"];
    myFile.folderName = file[@"folder_name"];
    myFile.filledOut = NO;
    myFile.file = nil;
    myFile.fileMemo = @"";
    myFile.fileUrl = nil;
    myFile.thumbnailUrl = nil;
    myFile.unparsedFile = nil;
    myFile.fileType = nil;
    myFile.fileSize = 0.0;
    myFile.created = nil;
    return myFile;
}

+(void)checkDelegate:(FileObject*)sender
{
    [sender succeedInGettingData];
}


-(void)getFileData:(FileObject*)file
{
    if (file != nil)
    {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://taxzoc.herokuapp.com/api/documents/%@?email=%@",file.fileID, [Defaults getUserDefaultForKey:@"email"]]];
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request addValue:[NSString stringWithFormat:@"Token token=%@",[Defaults getUserDefaultForKey:@"authorizationToken"]] forHTTPHeaderField:@"Authorization"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data != nil)
            {
                NSLog(@"data was recieved");
                NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
                file.unparsedFile = dictionary;
                NSLog(@"%@", dictionary);
                [self.delegate dataFetchComplete:[FileObject parseFile:file]];
            }
            else
            {
                [self.delegate dataFetchFailed];
                NSLog(@"No data");
            }
        }];
    }
    
    else
    {
        NSLog(@"No file");
    }
}

-(void)getFileFromFileObject:(FileObject*)fileObject
{
    NSData* pdfData = [[NSData alloc] initWithContentsOfURL:fileObject.fileUrl];
    NSString *resourceDocPath = [[NSString alloc]initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", fileObject.fileName]]];
    [pdfData writeToFile:resourceDocPath atomically:YES];
    fileObject.file = resourceDocPath;
    [self.delegate fileDataRecieved:fileObject.file];
}

+(FileObject*)parseFile:(FileObject*)file
{
    NSDictionary* dict =  file.unparsedFile;
    file.fileUrl = [NSURL URLWithString:dict[@"file"][@"url"]];
    file.thumbnailUrl = dict[@"file"][@"thumb"][@"url"];
    file.fileMemo = dict[@"memo"];
    if (file.fileMemo == nil)
    {
        file.fileMemo = @"";
    }
    file.folderName = dict[@"folder_name"];
    file.fileSize = [dict[@"file_size"] floatValue];
    NSDateFormatter* dateForm = [[NSDateFormatter alloc]init];
    [dateForm setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    file.created = [dateForm dateFromString:dict[@"created_at"]];
    file.fileType = dict[@"file_content_type"];
    return file;
}

#pragma --mark Setting/Getting methods


+(void)setMemo:(FileObject*)file
{
    
}

+(void)setDateUpdated:(FileObject*)file
{
    
}

+(void)deleteFile:(FileObject*)file
{
    //DELETE http://localhost:3000/api/documents/156?email=josh@gmail.com
    
}

+(void)createFile:(NSMutableDictionary*)fileToCreate
{
    NSData* json = [NSJSONSerialization dataWithJSONObject:fileToCreate options:NSJSONWritingPrettyPrinted error:nil];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://taxzoc.herokuapp.com/api/documents?email=%@", [Defaults getUserDefaultForKey:@"email"]]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request addValue:[NSString stringWithFormat:@"Token token=%@",[Defaults getUserDefaultForKey:@"authorizationToken"]] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:json];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@", connectionError);
        NSLog(@"the response is %@", response);
        //NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", string);
    }];
    
    //api/documents?email=josh@gmail.com
}

+(NSURL*)getFileUrl:(FileObject*)file
{
    return file.fileUrl;
}

+(id)fileFromFileObject:(FileObject*)fileObject
{
    if (fileObject.file != nil) {
        return fileObject.file;
    }
    
    else
    {
        return nil;
    }
}



@end




