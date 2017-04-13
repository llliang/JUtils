//
//  UIColor+hex.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "UIColor+hex.h"

@implementation UIColor (hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha {
    if (hexString == nil || (id)hexString == [NSNull null]) {
        return nil;
    }
    UIColor *col;
    
    if (![hexString hasPrefix:@"#"]) {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [UIColor
               colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
               green:((float)((hexValue & 0xFF00) >> 8))/255.0
               blue:((float)(hexValue & 0xFF))/255.0
               alpha:alpha];;
    } else {
        col = [UIColor clearColor];
    }
    return col;
}

@end
