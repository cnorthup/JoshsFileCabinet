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

-(void)dataFetchComplete:(FileObject*) sender;
-(void)dataFetchFailed;

@end

@interface FileObject : NSObject

@property NSString* fileName;
@property NSString* folderName;
@property NSString* fileMemo;
@property (nonatomic, weak) id <FileObjectDelegate> delegate;

+(FileObject*)initWithFile:(NSDictionary*)file;

-(void)getFile:(FileObject*)file;
@end