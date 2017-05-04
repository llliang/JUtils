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

struct TimeValid {
    BOOL valid;
    BOOL change;
};

static NetworkStatus networkStatus = NetworkStatusReachableViaWAN;

static struct TimeValid timeValid;

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
    
    if (netStatus == -1 || netStatus == 0) {
        [JHud showContent:@"网络异常"];
        failure(nil);
        return;
    }
    NSLog(@"\nhttp url = %@",[NSString stringWithFormat:@"%@%@",[[self class] host],url] );
    AFHTTPSessionManager *manager = [[self class] initializeAFManager];
    [manager.requestSerializer setTimeoutInterval:30];
    if (method == HTTPMethodGET) {
        [manager GET:[NSString stringWithFormat:@"%@%@",[[self class] host],url] parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (![self specialHandle:(NSHTTPURLResponse *)task.response responseObject:responseObject]) {
                failure(nil);
                return;
            }
            
            if (!timeValid.change) {
                timeValid.change = YES;
                timeValid.valid = [self getServiceDateFrom:(NSHTTPURLResponse *)task.response];
            }
            
            result(responseObject);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (![self specialHandle:(NSHTTPURLResponse *)task.response responseObject:nil]) {
                failure(nil);
                return;
            }
            failure(error);
        }];
    } else if (method == HTTPMethodPOST) {
        [manager POST:[NSString stringWithFormat:@"%@%@",[[self class] host],url] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (![self specialHandle:(NSHTTPURLResponse *)task.response responseObject:responseObject]) {
                failure(nil);
                return;
            }
            
            if (!timeValid.change) {
                timeValid.change = YES;
                timeValid.valid = [self getServiceDateFrom:(NSHTTPURLResponse *)task.response];
            }
            
            result(responseObject); 
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (![self specialHandle:(NSHTTPURLResponse *)task.response responseObject:nil]) {
                failure(nil);
                return;
            }
            failure(error);
        }];
    }
}

+ (BOOL)specialHandle:(NSHTTPURLResponse *)response responseObject:(id)object {
    return YES;
}


+ (BOOL)serviceDateValid {
    return timeValid.valid;
}

+ (BOOL)getServiceDateFrom:(NSHTTPURLResponse *)response {
    NSString *dateString = response.allHeaderFields[@"Date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *serviceDate = [dateFormatter dateFromString:dateString];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - [serviceDate timeIntervalSince1970];
    if (abs((int)time) < 150) {
        return YES;
    }
    return NO;
}

+ (void)uploadDatas:(NSArray *)datas withMethod:(HTTPMethod)method withTitles:(NSArray *)titles withParam:(NSDictionary *)param withUrl:(NSString *)url progress:(void(^)(CGFloat progress))progress result:(void(^)(id result))result failure:(void(^)(NSError *error))failure {
    
    NSInteger netStatus = [[self class] getNetworkStatus];
    
    if (netStatus == -1 || netStatus == 1) {
        [JHud showContent:@"网络异常"];
        failure(nil);
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
            failure(nil);
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
