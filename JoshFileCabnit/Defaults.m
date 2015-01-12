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

+(id)findPlaceInFolders
{
    [Defaults setUserDefaults:@[[NSNumber numberWithInt:0] , [Defaults getUserDefaultForKey:@"documents"], @false] forKeys:@[@"depthLevel", @"searchFolder", @"foundPlace"]];
    
    int z = 0;

    while (![[Defaults getUserDefaultForKey:@"foundPlace"] boolValue])
    {
        for (NSDictionary*folder in [Defaults getUserDefaultForKey:@"searchFolder"])
            {
                //NSLog(@"%@, %@", [folder[@"id"] description], [[Defaults getUserDefaultForKey:@"placeInFolders"]objectAtIndex:(int)[Defaults getUserDefaultForKey:@"depthLevel"]][@"id"]);
                
                if (([Defaults getUserDefaultForKey:@"placeInFolders"] == nil)||([[Defaults getUserDefaultForKey:@"placeInFolders"] count] == 0))
                {
                    [Defaults setUserDefaults:@[[Defaults getUserDefaultForKey:@"documents"], @true, @true] forKeys:@[@"currentFolder", @"foundPlace", @"atTopLevel"]];
                    break;
                }
                
                else{
                    
                    if (z < [[Defaults getUserDefaultForKey:@"placeInFolders"] count])
                    {
                        if ([[[[Defaults getUserDefaultForKey:@"placeInFolders"] objectAtIndex:z] description] isEqualToString:[[[Defaults getUserDefaultForKey:@"placeInFolders"] lastObject] description]])
                        {
                            if ([[folder[@"id"] description] isEqualToString:[[[Defaults getUserDefaultForKey:@"placeInFolders"]objectAtIndex:z] description]])
                            {
                                [Defaults setUserDefaults:@[@true, folder] forKeys:@[@"foundPlace", @"currentFolder"]];
                                break;
                            }
                            
                            
                        }
                        else
                        {
                            if ([[folder[@"id"] description] isEqualToString:[[[Defaults getUserDefaultForKey:@"placeInFolders"]objectAtIndex:z] description]])
                            {
                                z++;
                                NSNumber *x = @((int)[Defaults getUserDefaultForKey:@"depthLevel"] + 1);
                                [Defaults setUserDefaults:@[x, folder[@"subfolders"]] forKeys:@[@"depthLevel", @"searchFolder"]];
                                break;
                            }
                        }
                    }
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
