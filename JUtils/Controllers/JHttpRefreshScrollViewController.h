//
//  HttpScrollViewController.h
//  Gogenius
//
//  Created by Neo on 2017/4/7.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JBaseViewController.h"
#import "JDataModel.h"

@interface JHttpRefreshScrollViewController : JBaseViewController <UIScrollViewDelegate>

@property (nonatomic, strong) JDataModel *dataModel;
@property (nonatomic, strong) UIScrollView *containerView;

- (void)loadData;

- (void)loadSuccess:(BOOL)success;

@end
