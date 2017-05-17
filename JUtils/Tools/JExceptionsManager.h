//
//  JExceptionsManager.h
//  JUtils
//
//  Created by Neo on 2017/5/17.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JExceptionsManager : NSObject

+ (void)monitorException;

+ (NSData *)getExceptions;

@end
