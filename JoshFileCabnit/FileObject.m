//
//  FileObject.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 9/27/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "FileObject.h"
#import "Defaults.h"

@interface FileObject ()

@property NSString* fileID;
@property NSDictionary* unparsedFile;
@property NSString* fileMemo;
@property BOOL filledOut;


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
    return myFile;
}

+(void)checkDelegate:(FileObject*)sender
{
    [sender succeedInGettingData];
}


-(void)getFile:(FileObject*)file
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
                //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError]);
                //file.filledOut = YES;
                //file.file = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
                NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
                [self.delegate dataFetchComplete:dictionary];
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

+(FileObject*)parseFile:(FileObject*)file
{
    return file;
}

+(NSString*)getMemo:(FileObject *)file
{
    return file.fileMemo;
}



@end




