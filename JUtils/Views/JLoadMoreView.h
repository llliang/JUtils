//
//  LoadMoreTableViewCell.h
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JLoadMoreViewState) {
    JLoadMoreViewStateNormal,
    JLoadMoreViewStateLoading,
    JLoadMoreViewStateFailed,
};

@class JLoadMoreView;

@protocol JLoadMoreViewDelegate <NSObject>

- (void)loadMoreViewDidStartLoad:(JLoadMoreView *)view;
- (BOOL)loadMoreViewIsLoading:(JLoadMoreView *)view;

@end

@interface JLoadMoreView : UIView

@property (nonatomic, assign) id<JLoadMoreViewDelegate> delegate;
@property (nonatomic, assign) JLoadMoreViewState state;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)startLoad;

@end
