//
//  NSString+function.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "NSString+function.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (function)

- (NSString *) md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (uint32_t)strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

- (NSString *)urlEncode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]%. "]];
}

- (NSString *)urlDecode {
    return [self stringByRemovingPercentEncoding];
}

@end
