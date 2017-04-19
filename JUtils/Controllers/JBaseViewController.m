//
//  BaseViewController.m
//  Gogenius
//
//  Created by Neo on 2017/4/7.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JBaseViewController.h"
#import "UIBarButtonItem+custom.h"

@interface JBaseViewController ()

@end

@implementation JBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.backBarButtonItem = nil;
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:self.backImage target:self action:@selector(backAction) imageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
