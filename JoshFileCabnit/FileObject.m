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
@property NSDictionary* file;
@property BOOL filledOut;

@end

@implementation FileObject

+(FileObject*)initWithFile:(NSDictionary*)file
{
    FileObject* myFile = [FileObject new];
    myFile.fileName = file[@"name"];
    myFile.fileID = file[@"id"];
    myFile.folderName = file[@"folder_name"];
    myFile.filledOut = NO;
    return myFile;
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
                NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError]);
                file.filledOut = YES;
                file.file = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
            }
            else
            {
                NSLog(@"No data");
            }
        }];
    }
    
    else
    {
        NSLog(@"No file");
    }

}

@end