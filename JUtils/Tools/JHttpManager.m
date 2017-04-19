//
//  HttpManager.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JHttpManager.h"
#import "AFNetworking.h"
#import "JHud.h"

static NetworkStatus networkStatus = NetworkStatusUnknown;

static NSDate *serviceDate = nil;

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

+ (NetworkStatus)getNetworkStatus {
    return networkStatus;
}

+ (void)requestWithMethod:(HTTPMethod)method withParam:(NSDictionary *)param withUrl:(NSString *)url result:(void (^)(id))result failure:(void (^)(NSError *))failure {
    NSInteger netStatus = [[self class] getNetworkStatus];
    
    if (netStatus == -1 || netStatus == 1) {
        [JHud showContent:@"网络异常"];
        return;
    }
    NSLog(@"\nhttp url = %@",[NSString stringWithFormat:@"%@%@",[[self class] host],url] );
    AFHTTPSessionManager *manager = [[self class] initializeAFManager];
    
    if (method == HTTPMethodGET) {
        [manager GET:[NSString stringWithFormat:@"%@%@",[[self class] host],url] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (![self specialHandle:(NSHTTPURLResponse *)task.response responseObject:responseObject]) {
                return;
            }
            
            if (serviceDate == nil) {
                serviceDate = [self getServiceDateFrom:(NSHTTPURLResponse *)task.response];
            }
            
            result(responseObject);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
        }];
    } else if (method == HTTPMethodPOST) {
        [manager POST:[NSString stringWithFormat:@"%@%@",[[self class] host],url] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (![self specialHandle:(NSHTTPURLResponse *)task.response responseObject:responseObject]) {
                return;
            }
            
            if (serviceDate == nil) {
                serviceDate = [self getServiceDateFrom:(NSHTTPURLResponse *)task.response];
            }
            
            result(responseObject); 
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
        }];
    }
}

+ (BOOL)specialHandle:(NSHTTPURLResponse *)response responseObject:(id)object {
    return YES;
}

+ (NSDate *)serviceDate {
    return serviceDate;
}

+ (NSDate *)getServiceDateFrom:(NSHTTPURLResponse *)response {
    NSString *dateString = response.allHeaderFields[@"Date"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter dateFromString:dateString];
}

+ (void)uploadDatas:(NSArray *)datas withMethod:(HTTPMethod)method withTitles:(NSArray *)titles withParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress result:(void(^)(id result))result failure:(void(^)(NSError *error))failure {
    
    NSInteger netStatus = [[self class] getNetworkStatus];
    
    if (netStatus == -1 || netStatus == 1) {
        [JHud showContent:@"网络异常"];
        return;
    }
    
    AFHTTPSessionManager *manager = [[self class] initializeAFManager];
    NSLog(@"\nhttp url = %@",[NSString stringWithFormat:@"%@%@",[[self class] host],url] );

    [manager POST:[NSString stringWithFormat:@"%@%@",[[self class] host],url] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
        
        if (![self specialHandle:(NSHTTPURLResponse *)task.response responseObject:responseObject]) {
            return;
        }
        
        result(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (AFHTTPSessionManager *)initializeAFManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
//    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    // https cer
    manager.securityPolicy = [[self class] buildCustomSecurityPolicy];
    
    // 授权
    [manager.requestSerializer setValue:[[self class] httpHeaderAuthorization] forHTTPHeaderField:@"Authorization"];
    
    return manager;
}

+ (NSString *)host {
    return @"";
}

+ (AFSecurityPolicy *)buildCustomSecurityPolicy {
    return [AFSecurityPolicy defaultPolicy];
}

+ (NSString *)httpHeaderAuthorization {
    return @"";
}


@end
