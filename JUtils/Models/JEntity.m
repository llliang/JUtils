//
//  Entity.m
//  Gogenius
//
//  Created by Neo on 2017/4/6.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JEntity.h"
#import <objc/runtime.h>

@interface JEntity () {
    NSString *_projectName;
}

@end

@implementation JEntity

- (instancetype)init {
    if (self = [super init]) {
        _projectName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];

    }
    return self;
}

- (NSDictionary *)config {
    return @{};
}

+ (JEntity *)entityElement:(id)data{
    JEntity *entity = [[self alloc] init];
    [entity entityWithData:data];
    return entity;
}

- (void)entityWithData:(id)data {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t p = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(p) encoding:NSUTF8StringEncoding]; // 转成小写 以防驼峰式命名
        
        id tempData = [data objectForKey:propertyName];
        if (!tempData) {
            continue;
        }
        
        Class cls = [self getPropertyClass:p];
        
        if ([cls isSubclassOfClass:[NSArray class]]) {
            NSAssert([tempData isKindOfClass:[NSArray class]], @"属性和参数不统一");
            
            [self setValue:[self recursionArray:tempData forProperty:propertyName] forKey:propertyName];
        }else if ([cls isSubclassOfClass:[self class]]) {            
            NSAssert([tempData isKindOfClass:[NSDictionary class]], @"属性和参数不统一");
            
            JEntity *other = [[cls alloc] init]; 
            [other entityWithData:tempData];
            [self setValue:other forKey:propertyName];
        } else {
            [self setValue:tempData forKey:propertyName];
        }
    }
}   

- (NSArray *)recursionArray:(NSArray *)array forProperty:(NSString *)propertyName {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    
    for (int i = 0; i < array.count; i++) {
        id item = array[i];
        if ([item isKindOfClass:[NSArray class]]) {
            [tempArray replaceObjectAtIndex:i withObject:[self recursionArray:item forProperty:propertyName]];
        } else {
            // 用config 取类名 eg: config = {"users":"User"} 对用data {"users":[{"name":"xxx","age":"11"},{"name":"xxx","age":"11"}]}
            NSString *className = [[self config] objectForKey:propertyName];
            NSAssert((className!=nil && className.length>0), @"未正确配置参数");
            className = [NSString stringWithFormat:@"_TtC%lu%@%lu%@",_projectName.length,_projectName,className.length,className];
            Class cls = NSClassFromString(className);
            id otherEntity = [[cls alloc] init];
            [otherEntity entityWithData:item];
            [tempArray replaceObjectAtIndex:i withObject:otherEntity];
        }
    }
    return tempArray;
}

- (NSMutableDictionary *)reserveEntity {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t p = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(p) encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:propertyName];
        Class cls = [self getPropertyClass:p];
                
        if ([cls isSubclassOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (JEntity *item in value) {
                NSMutableDictionary *tempDic = [item reserveEntity];
                [tempArray addObject:tempDic];
            }
            [dic setValue:tempArray forKey:propertyName];
        } else if ([cls isSubclassOfClass:[JEntity class]]) {
            NSMutableDictionary *tempDic = [value reserveEntity];
            [dic setValue:tempDic forKey:propertyName];
        } else {
            [dic setValue:value forKey:propertyName];
        }
    }
    return dic;
}

- (Class)getPropertyClass:(objc_property_t)p {
    // 拿到属性的类型
    // 返回的是复杂的文本 通过规则取出我们要的类的名字pName == T@\"_TtC8BabyCare5BBaby\",N,&,Vbabies
    // 完整的类名 参考：property_getAttributes 格式 “_TtC” + 工程名字数+工程名+类名字数+类名 这样才可以反向得到一个类
    NSString *pName = [NSString stringWithCString:property_getAttributes(p) encoding:NSUTF8StringEncoding];
    // eg:  _TtC8BabyCare5BBaby
    NSArray *tempArray = [pName componentsSeparatedByString:@"\""];
    if (!tempArray || tempArray.count <= 1) {
        // 针对基础类型 简单返回Nil 并不代表真是Nil
        return Nil;
    }
    pName = [pName componentsSeparatedByString:@"\""][1];

    NSRange range = [pName rangeOfString:_projectName];
    if (range.length > 0) {
        pName = [pName substringFromIndex:range.location + range.length];
    }
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    pName = [pName stringByTrimmingCharactersInSet:set];
    return NSClassFromString(pName);
}

#pragma mark ------ encode decode

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self reserveEntity] forKey:@"coder"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    [self entityWithData:[aDecoder decodeObjectForKey:@"coder"]];
    return self;
}




@end
