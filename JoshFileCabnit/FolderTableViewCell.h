//
//  FolderTableViewCell.h
//  JoshFileCabnit
//
//  Created by Charles Northup on 9/17/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FileObject.h"


@interface FolderTableViewCell : UITableViewCell

@property NSString* folderID;
@property FileObject* cellFile;


@end