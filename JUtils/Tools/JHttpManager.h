//
//  HttpManager.h
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NetworkStatus) {
    NetworkStatusUnknown          = -1,
    NetworkStatusNotReachable     = 0,
    NetworkStatusReachableViaWAN  = 1,
    NetworkStatusReachableViaWiFi = 2,
};

typedef void(^NetworkChangeBlock)(NetworkStatus status);

@interface JHttpManager : NSObject

+ (void)monitorNetworkStatus:(NetworkChangeBlock)block;

+ (NetworkStatus)getNetworkStatus;

+ (void)requestResult:(void(^)(id result))result failureHandle:(void(^)(NSError *error))error; 


@end
