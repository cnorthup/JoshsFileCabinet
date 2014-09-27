//
//  FileObject.h
//  JoshFileCabnit
//
//  Created by Charles Northup on 9/27/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileObject : NSObject

@property NSString* fileName;
@property NSString* folderName;
@property NSString* fileMemo;

+(FileObject*)initWithFile:(NSDictionary*)file;

-(void)getFile:(FileObject*)file;

@end