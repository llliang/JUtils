//
//  DataModel.h
//  Gogenius
//
//  Created by Neo on 2017/4/6.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JDataModel : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong)id data;

@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL isReload;
@property (nonatomic) BOOL canLoadMore;

@property (nonatomic) NSInteger fetchLimited; // 每次取的条数
@property (nonatomic) NSInteger pageNum;


- (void)loadStart:(void(^)(void))startBlock finished:(void(^)(JDataModel *model))finishedBlock failure:(void(^)(NSError *error))failureBlock;

// 加载缓存
- (void)loadCache;

// 若需要缓存 指定key
- (NSString *)cacheKey;

@end

@interface JDataModel (list)

- (id)itemAtIndex:(NSInteger)index;

// 数量
- (NSInteger)itemCount;

// 
- (void)removeObject:(id)anObject;

// 移除
- (void)removeObjectAtIndex:(NSInteger)index;

// 
- (void)insertObject:(id)object atIndex:(NSUInteger)index;

// 
- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)object;

@end
