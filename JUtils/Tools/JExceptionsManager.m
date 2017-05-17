//
//  JExceptionsManager.m
//  JUtils
//
//  Created by Neo on 2017/5/17.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "JExceptionsManager.h"
#import "Macros.h"

@implementation JExceptionsManager

void UncaughtExceptionHandler(NSException * exception) {
    
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    
    //写入沙盒
    NSString * path = [JExceptionsManager exceptionsPath];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager createFileAtPath:path contents:nil attributes:nil];
    }
    NSError *error;
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        JLog(@"exceptions write error = %@",error.localizedDescription);
    }
}

+ (void)monitorException {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSString *)exceptionsPath {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"exception.txt"];
}

+ (NSData *)getExceptions {
    NSData *data = [NSData dataWithContentsOfFile:[self exceptionsPath]];
    return data;
}

@end
