//
//  Documents.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/29/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "Documents.h"

@interface Documents ()

@end

@implementation Documents

+(instancetype)myDocuments:(NSArray*)folders
{
    static Documents *documents = nil;
    if (!documents)
    {
        documents = [Documents new];
        documents.usersFolders = folders;
    }
    return documents;
}

+(void)getDocuments:(NSURL*)url
{
   // NSURL* myUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://taxzoc.herokuapp.com/api/folders?email=%@",email]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError* error;
        NSArray* folders = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        [Documents myDocuments:folders];
        
    }];
}



@end
