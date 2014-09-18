//
//  Defaults.h
//  JoshFileCabnit
//
//  Created by Charles Northup on 9/16/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Defaults : NSObject

+(instancetype)defaults;

//set one userdefault
+(void)setUserDefault:(id)object forkey:(NSString*)key;
//allows for mutiple user default objects to set to their keys at once
+(void)setUserDefaults:(NSArray*)objects forKeys:(NSArray *)keys;
+(id)getUserDefaultForKey:(NSString*)key;
+(NSDictionary*)findPlaceInFolders;

@end