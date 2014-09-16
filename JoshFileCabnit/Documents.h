//
//  Documents.h
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/29/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Documents : NSObject

+(instancetype)myDocuments:(NSArray*)folders;
+(void)getDocuments:(NSURL*)url;
@property NSArray* usersFolders;


@end
