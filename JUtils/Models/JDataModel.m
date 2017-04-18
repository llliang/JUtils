//
//  DataModel.m
//  Gogenius
//
//  Created by Neo on 2017/4/6.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JDataModel.h"
#import "JEntity.h"
#import "JHttpManager.h"
#import "JHud.h"
#import "JCacheManager.h"

@interface JDataModel () {
    
    NSInteger _fetchLimited; // 每次取的条数
}

@end

@implementation JDataModel

- (instancetype)init {
    if (self = [super init]) {
        _isReload = YES;
        _fetchLimited = NSIntegerMax;
    }
    return self;
}

- (NSString *)cacheKey {
    return nil;
}

- (void)loadStart:(void (^)())startBlock finished:(void (^)(JDataModel *))finishedBlock failure:(void (^)(NSError *))failureBlock{
    
    if (!self.loading) {
        
        startBlock();
        self.loading = YES;
        [JHttpManager requestWithMethod:[self method] withParam:[self param] withUrl:[self requestUrl] result:^(id result) {
            
            self.loading = NO;
            finishedBlock([self phaseData:result]);
            
        } failure:^(NSError *error) {
            
            self.loading = NO;
            failureBlock(error);
        }];
    }
}

- (HTTPMethod)method {
    return HTTPMethodGET;
}

- (NSDictionary *)param {
    return [NSDictionary dictionary];
}

- (NSString *)requestUrl {
    return @"";
}
// 实体化数据
- (id)entityData:(id)data {
    return [JEntity entityElement:data];
}

- (id)phaseData:(id)data {
    self.status = [[data objectForKey:@""] integerValue];
    self.message = [data objectForKey:@""];
    id tmpData = [data objectForKey:@""]; // 目标数据
//    // 若返回有问题
//    if (self.status) {
//        return self;
//    }
    if (!tmpData) {
        return self;
    }
    if ([tmpData count] < _fetchLimited) {
        _canLoadMore = NO;
    } else {
        _canLoadMore = YES;
    }
    
    if ([tmpData isKindOfClass:[NSArray class]]) {
                
        NSMutableArray *resultArray = [NSMutableArray array];
        
        for (id item in tmpData) {
            id entity = [self entityData:item];
            [resultArray addObject:entity];
        }
        
        if (_isReload) {
            self.data = resultArray;
            _isReload = NO;            
        } else {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.data];
            [tmpArray addObjectsFromArray:resultArray];
            self.data = tmpArray;
        }
        
    } else {
        self.data = [self entityData:tmpData];
    }
    
    NSString *cacheKey = [self cacheKey];
    
    if (cacheKey && cacheKey.length > 0) {
        [[JCacheManager sharedManager] setCache:self.data forKey:cacheKey];
    }
    
    return self;
}

- (void)loadCache {
    NSString *cacheKey = [self cacheKey];
    if (cacheKey && cacheKey.length > 0) {
       self.data = [[JCacheManager sharedManager] cacheForKey:cacheKey];
    }
}

@end


#pragma mark ----------------- category -------------------

@implementation JDataModel (list)

- (NSInteger)itemCount {
    if ([self.data isKindOfClass:[NSArray class]]) {
        return [self.data count];
    } else {
        return 1;
    }
}

- (void)removeObject:(id)anObject {
    if ([self.data isKindOfClass:[NSArray class]]) {
        [self.data removeObject:anObject];
    }
}

- (void)removeObjectAtIndex:(NSInteger)index {
    if ([self.data isKindOfClass:[NSArray class]]) {
        [self.data removeObjectAtIndex:index];
    }
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    if ([self.data isKindOfClass:[NSArray class]]) {
        [self.data insertObject:object atIndex:index];
    }
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object {
    if ([self.data isKindOfClass:[NSArray class]]) {
        [self.data replaceObjectAtIndex:index withObject:object];
    }
}

@end



