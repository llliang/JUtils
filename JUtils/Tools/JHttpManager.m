//
//  HttpManager.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JHttpManager.h"
#import "AFNetworking.h"

static NetworkStatus networkStatus = NetworkStatusUnknown;

@implementation JHttpManager

+ (void)monitorNetworkStatus:(NetworkChangeBlock)block {
    AFNetworkReachabilityManager *afReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%lu",(unsigned long)status);

        if (block) {
            block(status);
            networkStatus = status;
        }
    }];
    [afReachabilityManager startMonitoring];
}

+ (NetworkStatus)getNetworkStatus {
    return networkStatus;
}

+ (void)requestResult:(void (^)(id))result failureHandle:(void (^)(NSError *))error {
    
}


@end
