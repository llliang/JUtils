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

static NetworkStatus networkStatus = NetworkStatusReachableViaWAN;

@implementation JHttpManager

+ (void)monitorNetworkStatus:(NetworkChangeBlock)block {
    AFNetworkReachabilityManager *afReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        networkStatus = status;
        if (block) {
            block(status);
        }
    }];
    [afReachabilityManager startMonitoring];
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
    return networkStatus;
}

+ (NSURLSessionDataTask *)requestWithMethod:(HTTPMethod)method withParam:(NSDictionary *)param withUrl:(NSString *)url result:(void(^)(id resultObject))result failure:(void(^)(NSError *error))failure {
    return [self __requestWithMethod:method withParam:param withUrl:url result:^(NSURLSessionDataTask *task, id resultObject) {
        result(resultObject); 
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (NSURLSessionDataTask *)uploadDatas:(NSArray *)datas withMethod:(HTTPMethod)method withTitles:(NSArray *)titles withParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress result:(void(^)(id result))result failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self manager];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (datas.count == titles.count) {
            for (int i = 0; i < datas.count; i++) {
                [formData appendPartWithFileData:datas[i] name:titles[i] fileName:[NSString stringWithFormat:@"header%@.jpg",@(i)] mimeType:@"image/jpeg"];
            }
        } else {
            for (int i = 0; i < datas.count; i++) {
                [formData appendPartWithFileData:datas[i] name:titles[0] fileName:[NSString stringWithFormat:@"header%@.jpg",@(i)] mimeType:@"image/jpeg"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.completedUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    return task;
}

+ (NSURLSessionDownloadTask *)downloadWithParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress destination:(NSURL * (^)())destination result:(void(^)(NSURL *filePath))result failure:(void(^)(NSError *error))failure {
    
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

+ (NSURLSessionDataTask *)__requestWithMethod:(HTTPMethod)method withParam:(NSDictionary *)param withUrl:(NSString *)url result:(void(^)(NSURLSessionDataTask *task,id resultObject))result failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLSessionDataTask *task;
    
    if (method == HTTPMethodGET) {
        task = [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            result(task, responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    } else if (method == HTTPMethodPOST) {
        
        task = [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            result(task, responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
        }];
    }
    return task;
}

@end
