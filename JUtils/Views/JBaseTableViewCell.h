//
//  BaseTableViewCell.h
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct HorizontalEdgeInsets {
    CGFloat left, right;
}HorizontalEdgeInsets;

UIKIT_STATIC_INLINE HorizontalEdgeInsets  HorizontalEdgeInsetsMake(x,y){
    HorizontalEdgeInsets insets = {x,y};
    return insets;
}

@interface JBaseTableViewCell : UITableViewCell

@property (nonatomic)BOOL separatorShow;// 分割线 default YES

@property (nonatomic)HorizontalEdgeInsets separatorInsets; // 分隔线左右两边缩进

+ (CGFloat)cellHeightWithData:(id)data;

@end
