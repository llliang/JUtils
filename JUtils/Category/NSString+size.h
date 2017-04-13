//
//  NSString+size.h
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (size)

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
