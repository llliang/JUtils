//
//  NSString+size.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self boundingRectWithSize:size 
                              options:NSStringDrawingUsesLineFragmentOrigin 
                           attributes:@{NSFontAttributeName:font} 
                              context:nil].size;
}

@end
