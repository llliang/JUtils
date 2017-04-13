//
//  JCacheManager.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JCacheManager.h"
#import "FMDB.h"
#import "JUtil.h"

@interface JCacheManager () {
    FMDatabaseQueue *_dbQueue;
}

@end

@implementation JCacheManager

+ (JCacheManager *)sharedManager {
    static JCacheManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[JCacheManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self dbPath]];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            if (![db tableExists:@"cache"]) {
                [db executeUpdate:@"CREATE TABLE cache (key VARCHAR PRIMARY KEY NOT NULL, expiry TIMESTAMP NOT NULL, data BOLB)"];
            }
        }];
        [self clearExpiryCache];
    }
    return self;
}

- (NSString *)dbPath {
    NSString *rootPath = [JUtil getDocumentRootPath];
    NSString *docDir = [rootPath stringByAppendingPathComponent:@"cache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:docDir
                                  withIntermediateDirectories:YES 
                                                   attributes:nil 
                                                        error:NULL];
    }
    return [docDir stringByAppendingString:@"/data.db"];
}

- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key {
    [self setCache:cache forKey:key duration:90*24*60*60];
}

- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key duration:(NSInteger)duration {
    if (cache==nil||key==nil) {
        return;
    }
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"replace into cache (key, expiry, data) values (?,?,?)", key, [NSNumber numberWithFloat:duration>0?[[NSDate date] timeIntervalSince1970]+duration:0], [NSKeyedArchiver archivedDataWithRootObject:cache]];
    }];
}

- (id)cacheForKey:(NSString *)key {
    __block id<NSCoding> result = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select data from cache where key=? and (expiry>? or expiry=0)", key, [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]]];
        if ([rs next]) {
            result = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"data"]];
        }
        [rs close];
    }];
    return result;
}

- (BOOL)containsCache:(NSString *)key {
    __block BOOL result = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select key from cache where key=?", key];
        result = [rs next];
        [rs close];
    }];
    return result;
}

- (void)removeCache:(NSString *)key {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from cache where key=?", key];
    }];
}

- (void)clearCache {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"delete from cache", [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]]];
        }];
    });
}

- (void)clearExpiryCache {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"delete from cache where expiry<? and expiry!=0", [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]]];
        }];
    });
}

@end
