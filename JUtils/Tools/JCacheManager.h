//
//  JCacheManager.h
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCacheManager : NSObject

+ (JCacheManager *)sharedManager;

/**
 @param cache <NSCoding> 带缓存数据 
 @param key 缓存时的key 
 */
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key;

/**
 @param cache <NSCoding> 带缓存数据 
 @param key 缓存时的key 
 @param duration 缓存过期时间
 */
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key duration:(NSInteger)duration;

/**
 @param key 缓存数据时的key
 @return    缓存的数据
 */
- (id)cacheForKey:(NSString *)key;

/**
 @return 是否存在缓存
 */
- (BOOL)containsCache:(NSString *)key;

/** 根据key删除缓存 */
- (void)removeCache:(NSString *)key;

/** 清空所有缓存 */
- (void)clearCache;


@end
