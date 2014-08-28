//
//  CheckListPrototypeCell.h
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/28/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckListPrototypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;
@property BOOL completed;

@end