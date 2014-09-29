//
//  FileObject.h
//  JoshFileCabnit
//
//  Created by Charles Northup on 9/27/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileObject;

@protocol FileObjectDelegate <NSObject>//define delegate protocal

@required

-(void)dataFetchComplete:(NSDictionary*)object;
-(void)dataFetchFailed;

@end

@interface FileObject : NSObject

@property NSString* fileName;
@property NSString* folderName;
@property NSString* fileType;
@property float* fileSize;

@property (nonatomic, weak) id <FileObjectDelegate> delegate;

+(FileObject*)initWithFile:(NSDictionary*)file;
+(void)checkDelegate:(FileObject*)sender;
-(void)getFile:(FileObject*)file;
+(NSString*)getMemo:(FileObject*)file;

@end