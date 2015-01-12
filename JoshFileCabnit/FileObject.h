//
//  FileObject.h
//  JoshFileCabnit
//
//  Created by Charles Northup on 9/27/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

@class FileObject;

@protocol FileObjectDelegate <NSObject>//define delegate protocal

@required

-(void)fileDataRecieved:(id)file;
-(void)fileDataRecieveError;
-(void)dataFetchComplete:(FileObject*)object;
-(void)dataFetchFailed;

@optional

@end

@interface FileObject : NSObject

@property NSString* fileName;
@property NSString* folderName;
@property NSString* fileType;
@property float fileSize;
@property NSString* updatedLast;
@property NSString* fileMemo;

@property (nonatomic, weak) id <FileObjectDelegate> delegate;

-(void)getFileData:(FileObject*)file;
-(void)getFileFromFileObject:(FileObject*)fileObject;

+(FileObject*)initWithFile:(NSDictionary*)file;
+(void)checkDelegate:(FileObject*)sender;
+(NSURL*)getFileUrl:(FileObject*)file;


+(id)fileFromFileObject:(FileObject*)fileObject;
+(void)createFile:(NSDictionary*)fileToCreate;
+(void)deleteFile:(FileObject*)file;
+(void)setDateUpdated:(FileObject*)file;
+(void)setMemo:(FileObject*)file;








@end