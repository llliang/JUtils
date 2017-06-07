//
//  JPhotosPickerController.h
//  ImagesPickerController
//
//  Created by Neo on 2017/5/16.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "JBaseViewController.h"

typedef void(^PickerFinished)(NSMutableArray<PHAsset *> *assets);

@interface JPhotosPickerController : JBaseViewController

/// 最小选择数 default 1
@property (nonatomic, assign) NSInteger minNumberOfSelection;

/// 最大选择数 default 1
@property (nonatomic, assign) NSInteger maxNumberOfSelection;

@property (nonatomic, assign) PHAssetMediaType mediaType;

@property (nonatomic, strong) UIColor *tintColor;

/// 间隙 
@property (nonatomic, assign) CGFloat spacing;

/// 多少列
@property (nonatomic, assign) NSInteger columnNumber;

@property (nonatomic, strong) PickerFinished finishedBlock;

@end
