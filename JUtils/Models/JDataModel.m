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
    /// 作为下一个pagesize的关键字
    id _nextKeyValue;
}

@end

@implementation JDataModel

- (instancetype)init {
    if (self = [super init]) {
        _isReload = YES;
        _pageNum = 1;
        _fetchLimited = 20; // 若无指定默认20条
    }
    return self;
}

/// 应对多app key 不统一的问题

- (NSString *)statusKey {
    return @"code";
}

- (NSString *)messageKey {
    return @"message";
}

- (NSString *)dataKey {
    return @"result";
}

- (NSString *)pageKey {
    return @"pageNum";
}

- (NSString *)pageSizeKey {
    return @"pageSize";
}

- (NSString *)nextKeyValueKey {
    return @"nextKeyValueKey";
}

- (NSString *)cacheKey {
    return nil;
}



/// 针对于列表数据传入当前取值的最后一位的关键字的数据 作为分页的关键字段
/// 若返回有值则根据返回值取出相应的数据传给服务器
- (NSString *)nextValueKey {
    return nil;
}

- (HTTPMethod)method {
    return HTTPMethodGET;
}

- (NSDictionary *)param {
    return [NSDictionary dictionary];
}

- (void)setIsReload:(BOOL)isReload {
    _isReload = isReload;
    if (_isReload) {
        _pageNum = 1;
        _nextKeyValue = nil;
    }
}

- (NSString *)requestUrl {
    return @"";
}

- (Class)httpManager {
    return [JHttpManager class];
}

- (void)loadStart:(void (^)(void))startBlock finished:(void (^)(JDataModel *))finishedBlock failure:(void (^)(NSError *))failureBlock{
    
    if (!self.loading) {
        
        startBlock();
        self.loading = YES;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self param]];
        [dic setObject:@(_pageNum) forKey:[self pageKey]];
        [dic setObject:@(_fetchLimited) forKey:[self pageSizeKey]];
        if (_nextKeyValue) {
            [dic setObject:_nextKeyValue forKey:[self nextValueKey]];
        }
        
        [[self httpManager] requestWithMethod:[self method] withParam:dic withUrl:[self requestUrl] result:^(id result) {
            
            self.loading = NO;
            finishedBlock([self phaseData:result]);
            
        } failure:^(NSError *error) {
            self.loading = NO;
            failureBlock(error);
        }];
    }
}

// 实体化数据
- (id)entityData:(id)data {
    return [JEntity entityElement:data];
}

- (id)phaseData:(id)data {
    self.status = [[data objectForKey:[self statusKey]] integerValue];
    self.message = [data objectForKey:[self messageKey]];
    id tmpData = [data objectForKey:[self dataKey]]; // 目标数据
    // 若返回有问题
    if (self.status != 200 && self.status != 304) {
        return self;
    }
    if (!tmpData || [tmpData isKindOfClass:[NSString class]]) {
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
        
        if ([self nextValueKey]) {
            _nextKeyValue = [[tmpData lastObject] objectForKey:[self nextValueKey]];
        }
        
        _pageNum++;
        
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
    if (!self.data) {
        return 0;
    }
    if ([self.data isKindOfClass:[NSArray class]]) {
        return [self.data count];
    } else {
        return 1;
    }
}

- (id)itemAtIndex:(NSInteger)index {
    if (self.data && [self.data count] && index <= [self.data count] - 1) {
        return [self.data objectAtIndex:index];
    }
    return nil;
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



