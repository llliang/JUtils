//
//  HttpManager.h
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, NetworkStatus) {
    NetworkStatusUnknown          = -1,
    NetworkStatusNotReachable     = 0,
    NetworkStatusReachableViaWWAN  = 1,
    NetworkStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET,
    HTTPMethodPOST,
};

typedef void(^NetworkChangeBlock)(NetworkStatus status);

@interface JHttpManager : AFHTTPSessionManager

+ (void)monitorNetworkStatus:(NetworkChangeBlock)block;

+ (void)stopMonitoring;

/**
 获取网络状态
 @return NetworkStatus
 */

+ (JHttpManager *)manager;

+ (NetworkStatus)getNetworkStatus;

/**
 请求数据接口
 @param method HTTPMethod GET or POST
 @param param POST参数
 @param url URI
 @param result 完成回调
 @param failure 失败回调
 */
+ (NSURLSessionDataTask *)requestWithMethod:(HTTPMethod)method withParam:(NSDictionary *)param withUrl:(NSString *)url result:(void(^)(id resultObject))result failure:(void(^)(NSError *error))failure;

+ (NSURLSessionDataTask *)__requestWithMethod:(HTTPMethod)method withParam:(NSDictionary *)param withUrl:(NSString *)url result:(void(^)(NSURLSessionDataTask *task,id resultObject))result failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 上传二进制接口
 @param datas 二进制数组
 @param names names
 @param param POST参数
 @param url URI
 @param progress 上传进度
 @param result 完成回调
 @param failure 失败回调
 */ 
+ (NSURLSessionDataTask *)uploadDatas:(NSArray<NSData *> *)datas withNames:(NSArray *)names fileNames:(NSArray *)fileNames mimeTypes:(NSArray *)mimeTypes withParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress result:(void(^)(id result))result failure:(void(^)(NSError *error))failure;

+ (NSURLSessionDownloadTask *)downloadWithParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress destination:(NSURL * (^)(void))destination result:(void(^)(NSURL *filePath))result failure:(void(^)(NSError *error))failure;


@end
