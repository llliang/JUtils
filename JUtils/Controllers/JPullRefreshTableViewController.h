//
//  HttpScrollViewController.h
//  Gogenius
//
//  Created by Neo on 2017/4/7.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JBaseViewController.h"
#import "JDataModel.h"

@interface JPullRefreshTableViewController : JBaseViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) __block JDataModel *dataModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *noDataView;

- (void)loadData;

- (void)refreshData;

- (void)loadSuccess:(BOOL)success;

@end
