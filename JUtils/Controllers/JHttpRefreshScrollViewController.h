//
//  HttpScrollViewController.h
//  Gogenius
//
//  Created by Neo on 2017/4/7.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JBaseViewController.h"
#import "JDataModel.h"

@interface JHttpRefreshScrollViewController : JBaseViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) __block JDataModel *dataModel;
@property (nonatomic, strong) UIScrollView *containerView;

- (void)loadData;

- (void)loadSuccess:(BOOL)success;

@end
