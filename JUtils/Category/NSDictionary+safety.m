//
//  NSDictionary+safety.m
//  JUtils
//
//  Created by Neo on 2017/6/9.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "NSDictionary+safety.h"

@implementation NSDictionary (safety)

@end

#pragma mark ------ NSMutableDictionary

@implementation NSMutableDictionary (safety)

- (void)setSafetyObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
