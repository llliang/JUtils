//
//  BaseTableViewCell.m
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JBaseTableViewCell.h"
#import "JOnePixLineView.h"
#import "UIView+frame.h"
#import "UIColor+hex.h"

HorizontalEdgeInsets HorizontalEdgeInsetsMake(CGFloat x,CGFloat y) {
    HorizontalEdgeInsets insets = {x, y};
    return insets;
}

@interface JBaseTableViewCell () {
    JOnePixLineView *_sepLineView;
}

@end

@implementation JBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _sepLineView = [[JOnePixLineView alloc] initWithFrame:CGRectMake(0.f, self.height-1, self.width, 1)];
        _sepLineView.lineColor = [UIColor colorWithHexString:@"e1e1e1" alpha:1];
        _sepLineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_sepLineView];
    }
    return self;
}

- (void)setSeparatorShow:(BOOL)separatorShow{
    _sepLineView.hidden = !separatorShow;
    if (separatorShow) {
        [self.contentView bringSubviewToFront:_sepLineView];
    }
}

- (void)setSeparatorInsets:(HorizontalEdgeInsets)separatorInsets {
    _separatorInsets = separatorInsets;
    _sepLineView.left = separatorInsets.left;
    _sepLineView.width = self.width - separatorInsets.left - separatorInsets.right;
}

+ (CGFloat)cellHeightWithData:(id)data{
    return 44;
}

@end
