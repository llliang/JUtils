//
//  BaseViewController.m
//  Gogenius
//
//  Created by Neo on 2017/4/7.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JBaseViewController.h"
#import "UIBarButtonItem+custom.h"
#import "UIColor+hex.h"

@interface JBaseViewController ()

@end

@implementation JBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f3f3" alpha:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.titleView = nil;
}

@end
