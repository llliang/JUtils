//
//  RefreshView.h
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RefreshState) {
    RefreshStateNormal,                       // 
    RefreshViewPullingCanRefresh,             // 松开即可刷新
    RefreshStateLoading,                      // 正在加载
};

@class JRefreshView;

@protocol JRefreshViewDelegate <NSObject>

- (void)pullRefreshTableHeaderDidTriggerRefresh:(JRefreshView *)view;
- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(JRefreshView *)view;

@end

@interface JRefreshView : UIView

@property (nonatomic, assign) RefreshState state;
@property (nonatomic, assign) id<JRefreshViewDelegate> delegate;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
