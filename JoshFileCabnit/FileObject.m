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
    [self sendPicture];
    [self uploadImage];
    NSData* json = [NSJSONSerialization dataWithJSONObject:fileToCreate options:NSJSONWritingPrettyPrinted error:nil];
    NSData* newData = [fileToCreate.description dataUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://taxzoc.herokuapp.com/api/documents?email=%@", [Defaults getUserDefaultForKey:@"email"]]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request addValue:[NSString stringWithFormat:@"Token token=%@",[Defaults getUserDefaultForKey:@"authorizationToken"]] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:newData];
    [request setHTTPMethod:@"POST"];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        //NSLog(@"%@", connectionError);
//        //NSLog(@"the response is %@", response);
//        NSLog(@"create file response %@", response);
//
//    }];
    
    //api/documents?email=josh@gmail.com
}

+(void)sendPicture
{

    UIImage* image = [UIImage imageNamed:@"bear"];
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://taxzoc.herokuapp.com/api/documents?email=cpa@example.com"]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request addValue:[NSString stringWithFormat:@"Token token=%@",[Defaults getUserDefaultForKey:@"authorizationToken"]] forHTTPHeaderField:@"Authorization"];
    
    
    NSString *boundary = @"---------FileCabnitBoundry";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSString *accept = @"application/json";
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //[request setValue:accept forHTTPHeaderField: @"Accept"];
    [request setHTTPMethod:@"POST"];
//
//    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"bla.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
  //  [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[NSData dataWithData:imageData]];
    
   // [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
   /// NSString* kioskID = @"WEBrick/1.3.1";
    //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"kiosk\"\r\n\r\n%@", kioskID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"response for different method %@", response);
        NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"data is %@", string);

    }];
    
//    NSMutableData *body = [NSMutableData data];
//    
//    // file
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]
//                      dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition:attachment; name=\"userfile\"; filename=\".jpg\"\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type:application/octet-stream\r\n\r\n"
//                      
//                      dataUsingEncoding:NSUTF8StringEncoding]];
//     [body appendData:[NSData dataWithData:imageData]];
//     [body appendData:[@"\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
//     
//     // text parameter
//     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]
//                       dataUsingEncoding:NSUTF8StringEncoding]];
//     [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"parameter1\"\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding]];
//     //[body appendData:[parameterValue1 dataUsingEncoding:NSUTF8StringEncoding]];
//     [body appendData:[@"\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
//     
//     // another text parameter
//     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]dataUsingEncoding:NSUTF8StringEncoding]];
//     [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"parameter2\"\r\n\r\n"]dataUsingEncoding:NSUTF8StringEncoding]];
//     //[body appendData:[parameterValue2 dataUsingEncoding:NSUTF8StringEncoding]];
//     [body appendData:[@"\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
//     
//     // close form
//     [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary]
//                       dataUsingEncoding:NSUTF8StringEncoding]];
//     
//     // set request body
//     [request setHTTPBody:body];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSLog(@"sendPicture response %@", response);
//        NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //NSLog(@"data is %@", string);
//    
//    }];
    
}
+(void)uploadImage {
    /*
     turning the image into a NSData object
     getting the image back out of the UIImageView
     setting the quality to 90
     */
    UIImage* image = [UIImage imageNamed:@"bear"];
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    // setting up the URL to post to
    NSString *urlString = [NSString stringWithFormat:@"http://taxzoc.herokuapp.com/api/documents?email=%@", [Defaults getUserDefaultForKey:@"email"]];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request addValue:[NSString stringWithFormat:@"Token token=%@",[Defaults getUserDefaultForKey:@"authorizationToken"]] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@", request);
    
    /*
     add some header info now
     we always need a boundary when we post a file
     also we need to set the content type
     
     You might want to generate a random boundary.. this is just the same
     as my output from wireshark on a valid html post
     */
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /*
     now lets create the body of the post
     */
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        //NSLog(@"upload response %@", response);
//        
//    }];
    //NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //NSLog(returnString);
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




