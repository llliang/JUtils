//
//  NSDictionary+safety.h
//  JUtils
//
//  Created by Neo on 2017/6/9.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safety)

@end


@interface NSMutableDictionary (safety)

- (void)setSafetyObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
