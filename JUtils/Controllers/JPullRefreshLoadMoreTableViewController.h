//
//  HttpRefreshLoadMoreScrollViewController.h
//  Gogenius
//
//  Created by Neo on 2017/4/10.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JPullRefreshTableViewController.h"
#import "JLoadMoreView.h"

@interface JPullRefreshLoadMoreTableViewController : JPullRefreshTableViewController

@property (nonatomic, strong) JLoadMoreView *loadMoreView;

@end
