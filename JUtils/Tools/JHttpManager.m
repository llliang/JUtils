//
//  HttpManager.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JHttpManager.h"
#import "JHud.h"
#import "Macros.h"
#import "AFNetworking.h"


@implementation JHttpManager

+ (void)monitorNetworkStatus:(NetworkChangeBlock)block {
    AFNetworkReachabilityManager *afReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (block) {
            block(status);
        }
    }];
    [afReachabilityManager startMonitoring];
}

+ (void)stopMonitoring {
    AFNetworkReachabilityManager *afReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afReachabilityManager stopMonitoring];
}

+ (JHttpManager *)manager {
    static JHttpManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (NetworkStatus)getNetworkStatus {
    
    AFNetworkReachabilityManager *afReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    return afReachabilityManager.networkReachabilityStatus;
}

+ (NSURLSessionDataTask *)requestWithMethod:(HTTPMethod)method withParam:(NSDictionary *)param withUrl:(NSString *)url result:(void(^)(id resultObject))result failure:(void(^)(NSError *error))failure {
    return [self __requestWithMethod:method withParam:param withUrl:url result:^(NSURLSessionDataTask *task, id resultObject) {
        result(resultObject); 
    } failure:^(NSURLSessionDataTask *task,NSError *error) {
        failure(error);
    }];
}

+ (NSURLSessionDataTask *)uploadDatas:(NSArray<NSData *> *)datas withNames:(NSArray *)names fileNames:(NSArray *)fileNames mimeTypes:(NSArray *)mimeTypes withParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress result:(void(^)(id result))result failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self manager];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (datas.count == names.count) {
            for (int i = 0; i < datas.count; i++) {
                [formData appendPartWithFileData:datas[i] name:names[i] fileName:fileNames[i] mimeType:mimeTypes[i]];
            }
        } else {
            for (int i = 0; i < datas.count; i++) {
                [formData appendPartWithFileData:datas[i] name:names[0] fileName:fileNames[0] mimeType:mimeTypes[0]];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress((CGFloat)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    return task;
}

+ (NSURLSessionDownloadTask *)downloadWithParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress destination:(NSURL * (^)(void))destination result:(void(^)(NSURL *filePath))result failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self manager];
    
    NSURL *requestUrl = [NSURL URLWithString:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:requestUrl] progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return destination(); 
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            JLog(@"error = %@",error);
        }
        result(filePath);
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)__requestWithMethod:(HTTPMethod)method withParam:(NSDictionary *)param withUrl:(NSString *)url result:(void(^)(NSURLSessionDataTask *task,id resultObject))result failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionDataTask *task;
    
    if (method == HTTPMethodGET) {
        task = [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            result(task, responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task,error);
        }];
    } else if (method == HTTPMethodPOST) {
        
        task = [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            result(task, responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(task,error);
        }];
    }
    return task;
}

@end
