//
//  Defaults.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 9/16/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "Defaults.h"

@interface Defaults ()

@end

@implementation Defaults

+(instancetype)defaults
{
    Defaults* defaults = nil;
    if (!defaults)
    {
        defaults = [Defaults new];
    }
    return defaults;
}

//for setting one userDefault

+(void)setUserDefault:(id)object forkey:(NSString *)key
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}


+(void)setUserDefaults:(NSArray*)objects forKeys:(NSArray *)keys
{
    //checks to see if there the same number of keys and objects
    if (objects.count == keys.count)
    {
        //enumerates over them and sets userdefaults to keys
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        for (int x = 0; x <= objects.count-1 ; x++)
        {
            [userDefaults setObject:[objects objectAtIndex:x] forKey:[keys objectAtIndex:x]];
            [userDefaults synchronize];
        }

    }
}

+(id)getUserDefaultForKey:(NSString *)key
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(NSDictionary*)findPlaceInFolders
{
    [Defaults setUserDefaults:@[@0, [Defaults getUserDefaultForKey:@"documents"], @false] forKeys:@[@"depthLevel", @"searchFolder", @"foundPlace"]];
    
    while ([Defaults getUserDefaultForKey:@"foundPlace"] == false)
    {
        for (NSDictionary*folder in [Defaults getUserDefaultForKey:@"searchFolder"])
            {
                if (([folder[@"id"] isEqualToString:[[Defaults getUserDefaultForKey:@"placeInFolders"]objectAtIndex:(int)[Defaults getUserDefaultForKey:@"depthLevel"]][@"id"]])&&((int)[Defaults getUserDefaultForKey:@"depthLevel"] != ([[Defaults getUserDefaultForKey:@"placeInFolder"] count] - 1)))
                {
                    NSNumber *x = @((int)[Defaults getUserDefaultForKey:@"depthLevel"] + 1);
                    [Defaults setUserDefaults:@[x, folder[@"subfolder"]] forKeys:@[@"depthLevel", @"searchFolder"]];
                    break;
                }
                else if(([folder[@"id"] isEqualToString:[[Defaults getUserDefaultForKey:@"placeInFolders"]objectAtIndex:(int)[Defaults getUserDefaultForKey:@"depthLevel"]][@"id"]])&&((int)[Defaults getUserDefaultForKey:@"depthLevel"] == ([[Defaults getUserDefaultForKey:@"placeInFolder"] count] - 1)))
                {
                    [Defaults setUserDefaults:@[@true, folder] forKeys:@[@"foundPlace", @"currentFolder"]];
                    break;
                }
        
            }
    }
    return [Defaults getUserDefaultForKey:@"currentFolder"];
}

+(void)synchronizeDefaults
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
