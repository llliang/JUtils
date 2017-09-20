//
//  HttpScrollViewController.m
//  Gogenius
//
//  Created by Neo on 2017/4/7.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JHttpRefreshScrollViewController.h"
#import "JRefreshView.h"
#import "UIView+frame.h"

@interface JHttpRefreshScrollViewController () <JRefreshViewDelegate> {
    JRefreshView *_refreshView;
}

@end

@implementation JHttpRefreshScrollViewController

- (void)dealloc {
    [_containerView removeObserver:self forKeyPath:@"tableHeaderView"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _containerView = [[[self getContainerViewClass] alloc] initWithFrame:self.view.bounds];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _containerView.backgroundColor = [UIColor clearColor];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
    if (![_containerView isKindOfClass:[UIScrollView class]]) {
        NSAssert(NO, @"容器类不是UIScrollView子类");
    }
    _containerView.delegate = self;
    [self.view addSubview:_containerView];
    
    if ([_containerView isKindOfClass:[UITableView class]]) {
        [(UITableView *)_containerView setDataSource:self];
        [(UITableView *)_containerView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    if ([_containerView isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)_containerView setDataSource:self];
    }
    
    _refreshView = [[JRefreshView alloc] initWithFrame:CGRectMake(0, -60, _containerView.width, 60)];
    _refreshView.delegate = self;
    [_containerView addSubview:_refreshView];
    
    _noDataView = [self createNoDataView];
    _noDataView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
    [_containerView addSubview:_noDataView];
    
    _noDataView.hidden = YES;
    
    _dataModel = [self createDataModel];
    if (_dataModel.data && [_dataModel.data count]) {
        if ([_containerView respondsToSelector:@selector(reloadData)]) {
            [_containerView performSelector:@selector(reloadData)];
        }
    }
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.01];
    [_containerView addObserver:self forKeyPath:@"tableHeaderView" options:NSKeyValueObservingOptionNew context:nil];
}

- (UIView *)createNoDataView {
    UIView *view = [[UIView alloc] initWithFrame:_containerView.bounds];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshData)];
    [view addGestureRecognizer:gestureRecognizer];
    return  view;
}

- (void)loadData {
    [_dataModel loadStart:^{
        
    } finished:^(JDataModel *model) {
        [self loadSuccess:YES];
    } failure:^(NSError *error) {
        [self loadSuccess:NO];
    }];
}

// 加载完成
- (void)loadSuccess:(BOOL)success {
 
    [_refreshView refreshScrollViewDataSourceDidFinishedLoading:_containerView];
    
    _noDataView.hidden = success;
    
    if ([_containerView respondsToSelector:@selector(reloadData)]) {
        [_containerView performSelector:@selector(reloadData)];
    }
}

- (void)refreshData {
    self.dataModel.isReload = YES;
    [self loadData];
}


#pragma mark ---------- 子类需重写的方法
// 此方法子类可重载
- (Class)getContainerViewClass {
    return [UITableView class];
}

- (JDataModel *)createDataModel {
    JDataModel *dataModel = [[JDataModel alloc] init]; 
    return dataModel;
}

#pragma mark -------- container View delegate && data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshView refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshView refreshScrollViewDidEndDragging:scrollView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[UICollectionViewCell alloc] init];
}

#pragma mark -------- refreshView  delegate

- (void)pullRefreshTableHeaderDidTriggerRefresh:(JRefreshView *)view {
    [self refreshData];
}

- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(JRefreshView *)view {
    return  self.dataModel.loading;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if ([object isKindOfClass:[UITableView class]]) {
        
        UIView *headerView = [(UITableView *)_containerView tableHeaderView];
        _noDataView.top = headerView.height;
        _noDataView.height = _containerView.height - headerView.height;
    }
}

@end
