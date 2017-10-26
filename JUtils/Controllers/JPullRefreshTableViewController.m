//
//  HttpScrollViewController.m
//  Gogenius
//
//  Created by Neo on 2017/4/7.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JPullRefreshTableViewController.h"
#import "JRefreshView.h"
#import "UIView+frame.h"

@interface JPullRefreshTableViewController () <JRefreshViewDelegate> {
    JRefreshView *_refreshView;
}

@end

@implementation JPullRefreshTableViewController

- (void)dealloc {
    [_tableView removeObserver:self forKeyPath:@"tableHeaderView"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
    _refreshView = [[JRefreshView alloc] initWithFrame:CGRectMake(0, -60, _tableView.width, 60)];
    _refreshView.delegate = self;
    [_tableView addSubview:_refreshView];
    
    _noDataView = [self createNoDataView];
    _noDataView.layer.masksToBounds = YES;
    _noDataView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
    [_tableView addSubview:_noDataView];
    
    _noDataView.hidden = YES;
    
    _dataModel = [self createDataModel];
    if (_dataModel.data && [_dataModel itemCount] > 0) {
        [_tableView reloadData];
    }
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.01];
    // 监控tableview 的headerView 更改noDataView的位置
    [_tableView addObserver:self forKeyPath:@"tableHeaderView" options:NSKeyValueObservingOptionNew context:nil];
}

- (UIView *)createNoDataView {
    UIView *view = [[UIView alloc] initWithFrame:_tableView.bounds];
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
 
    [_tableView reloadData];    
    [_refreshView refreshScrollViewDataSourceDidFinishedLoading:_tableView];
    
    if (success && [self.dataModel.data isKindOfClass:[NSArray class]] && [self.dataModel itemCount] == 0) {
        _noDataView.hidden = NO;
    } else {
        _noDataView.hidden = YES;
    } 
}

- (void)refreshData {
    self.dataModel.isReload = YES;
    [self loadData];
}

#pragma mark ---------- 子类需重写的方法

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

#pragma mark -------- refreshView  delegate

- (void)pullRefreshTableHeaderDidTriggerRefresh:(JRefreshView *)view {
    [self refreshData];
}

- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(JRefreshView *)view {
    return  self.dataModel.loading;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if ([object isKindOfClass:[UITableView class]]) {
        
        UIView *headerView = [(UITableView *)_tableView tableHeaderView];
        _noDataView.top = headerView.height;
        _noDataView.height = _tableView.height - headerView.height;
    }
}

@end
