//
//  Entity.h
//  Gogenius
//
//  Created by Neo on 2017/4/6.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JEntity : NSObject<NSCoding>

+ (JEntity *)entityElement:(id)data;

- (void)print;

@end
