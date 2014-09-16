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



@end
