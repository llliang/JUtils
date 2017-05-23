//
//  HttpManager.h
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, NetworkStatus) {
    NetworkStatusUnknown          = -1,
    NetworkStatusNotReachable     = 0,
    NetworkStatusReachableViaWAN  = 1,
    NetworkStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET,
    HTTPMethodPOST,
};

typedef void(^NetworkChangeBlock)(NetworkStatus status);

@interface JHttpManager : NSObject

+ (void)monitorNetworkStatus:(NetworkChangeBlock)block;

/**
 获取网络状态
 @return NetworkStatus
 */
+ (NetworkStatus)getNetworkStatus;

/**
 请求数据接口
 @param method HTTPMethod GET or POST
 @param param POST参数
 @param url URI
 @param result 完成回调
 @param failure 失败回调
 */
+ (void)requestWithMethod:(HTTPMethod)method withParam:(NSDictionary *)param withUrl:(NSString *)url result:(void(^)(id result))result failure:(void(^)(NSError *error))failure;


/**
 上传二进制接口
 @param datas 二进制数组
 @param method HTTPMethod GET or POST
 @param titles titles
 @param param POST参数
 @param url URI
 @param progress 上传进度
 @param result 完成回调
 @param failure 失败回调
 */
+ (void)uploadDatas:(NSArray *)datas withMethod:(HTTPMethod)method withTitles:(NSArray *)titles withParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress result:(void(^)(id result))result failure:(void(^)(NSError *error))failure;

+ (void)downloadWithParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress destination:(NSURL * (^)())destination result:(void(^)(NSURL *filePath))result failure:(void(^)(NSError *error))failure;

// 校验服务器时间与本地时间最大差值
+ (BOOL)serviceDateValid;


+ (NSString *)host;

+ (AFHTTPSessionManager *)manager;

@end
