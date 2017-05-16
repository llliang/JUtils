//
//  JPhotosPickerController.m
//  ImagesPickerController
//
//  Created by Neo on 2017/5/16.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "JPhotosPickerController.h"
#import "UIView+frame.h"
#import "UIColor+hex.h"

@interface PhotosAssetsCollectionViewLayout : UICollectionViewFlowLayout

@end

@implementation PhotosAssetsCollectionViewLayout

- (instancetype)init {
    self = [super init]; 
    if (self) {
        self.minimumLineSpacing = 5.0;
        self.minimumInteritemSpacing = 5.0;
    }
    return self;
}

@end

#pragma mark ------------ separator -------------

@protocol PhotosBottomContainerViewDelegate <NSObject>

- (void)bottomContainerSure;

@end

@interface PhotosBottomContainerView : UIView {
    UIScrollView *_scrollView;
    UILabel *_noDataLabel;
    UIButton *_sureButton;
    UILabel *_countLabel;
    
    __block NSMutableArray *_container;
}

/// 最大数量
@property (nonatomic, assign) NSInteger maxNumber;
@property (nonatomic, strong) NSArray *assets;

@property (nonatomic, assign) id<PhotosBottomContainerViewDelegate> delegate;

@end

@implementation PhotosBottomContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor colorWithHexString:@"e1e1e1" alpha:1] CGColor];
        self.layer.borderWidth = 0.5;
        
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 16 - 50, 10.f, 50.f, 50.f)];
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"c1c1c1" alpha:1];
        [_sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureButton];
        
        _countLabel = [[UILabel alloc] initWithFrame:_sureButton.bounds];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.numberOfLines = 0;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [_sureButton addSubview:_countLabel];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(16.f, 0.f, self.width - 16 - 16 - 50 -20, self.height)];
        [self addSubview:_scrollView];
        
        _noDataLabel = [[UILabel alloc] initWithFrame:_scrollView.bounds];
        _noDataLabel.font = [UIFont systemFontOfSize:14];
        _noDataLabel.textColor = [UIColor colorWithHexString:@"666666" alpha:1];
        _noDataLabel.text = @"请先选择图片";
        [_scrollView addSubview:_noDataLabel];
        
        _container = [NSMutableArray array];
    }
    return self;
}

- (void)setMaxNumber:(NSInteger)maxNumber {
    _maxNumber = maxNumber;
    _countLabel.text = [NSString stringWithFormat:@"确定\n0/%@",@(self.maxNumber)];
}

- (void)setAssets:(NSArray *)assets {
    _assets = assets;
    
    if (assets && assets.count) {
        _noDataLabel.hidden = YES;
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"f95959" alpha:1];
    } else {
        _noDataLabel.hidden = NO;
        _sureButton.backgroundColor = [UIColor colorWithHexString:@"c1c1c1" alpha:1];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"确定\n%@/%@",@(assets.count),@(self.maxNumber)];    
    [_container makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_container removeAllObjects];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width + 1, _scrollView.height);
    
    [_assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = obj;
        UIButton * item = [[UIButton alloc] initWithFrame:CGRectMake((50 + 10)*idx, 10, 50, 50)];
        [_scrollView addSubview:item];
        [_container addObject:item];
        
        item.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _scrollView.contentSize = CGSizeMake(MAX(_scrollView.width + 1, item.right + 1), _scrollView.height);
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];  
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = YES; 
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:item.bounds.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [item setBackgroundImage:result forState:UIControlStateNormal];
        }];
    }];
}

- (void)sure {
    if ([_delegate respondsToSelector:@selector(bottomContainerSure)]) {
        [_delegate bottomContainerSure];
    }
}

@end

#pragma mark ------------ separator -------------

@interface PhotosCollectionViewCell : UICollectionViewCell {
    UIImageView *_imageView;
    UIImageView *_markedImageView; // 标记选择或者未选择
    
    UIView *_maskView; // 蒙版
}

@property (nonatomic, strong) PHAsset *asset;

@end

@implementation PhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.masksToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.7];
        [self.contentView addSubview:_maskView];
        _maskView.hidden = YES;
        
        _markedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 4 - 15, 4, 15, 15)];
        _markedImageView.image = [self getImageFromBundle:@"imagepicker_unselected"];//[UIImage imageNamed:@"imagepicker_unselected"];
        [self.contentView addSubview:_markedImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _maskView.hidden = !selected;
    if (selected) {
        _markedImageView.image = [UIImage imageNamed:@"imagepicker_selected"];
    } else {
        _markedImageView.image = [self getImageFromBundle:@"imagepicker_unselected"];
        
    }
}

- (UIImage *)getImageFromBundle:(NSString *)imageName {
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"JUtil.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *img_path = [bundle pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:img_path];
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];  
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES; 
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:_imageView.bounds.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        _imageView.image = result; 
    }];
}

@end

#pragma mark ------------ separator -------------

@interface JPhotosPickerController () <UICollectionViewDelegateFlowLayout, PhotosBottomContainerViewDelegate> {
    PHFetchResult *_fetchResult;
    
    NSMutableArray *_selectedArray;
    PhotosBottomContainerView *_bottomView;
}

@end

@implementation JPhotosPickerController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    self = [self initWithCollectionViewLayout:[[PhotosAssetsCollectionViewLayout alloc] init]];
    if (self) {
        _spacing = 5;
        _columnNumber = 4;
        _bottomView.maxNumber = _maxNumberOfSelection = 1;
        _minNumberOfSelection = 1;
        _selectedArray = [NSMutableArray array];
        _mediaType = PHAssetMediaTypeImage;
        
        _fetchResult = [self getPhotosResult];
    }
    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        // View settings
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        // Register cell class
        [self.collectionView registerClass:[PhotosCollectionViewCell class]
                forCellWithReuseIdentifier:reuseIdentifier];
        self.collectionView.allowsMultipleSelection = YES;
        
        self.collectionView.alwaysBounceVertical = YES;
        if (self.collectionView.contentSize.height <= self.collectionView.frame.size.height) {
            [self.collectionView setContentSize:CGSizeMake(self.collectionView.contentSize.width, self.collectionView.contentSize.height+1)];
        }
        
        _bottomView = [[PhotosBottomContainerView alloc] initWithFrame:CGRectMake(0, self.view.height - 70, self.view.width, 70)];
        _bottomView.delegate = self;
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:_bottomView];
        
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height - _bottomView.height);
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

- (void)setMaxNumberOfSelection:(NSInteger)maxNumberOfSelection {
    _maxNumberOfSelection = maxNumberOfSelection;
    _bottomView.maxNumber = maxNumberOfSelection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (PHFetchResult *)getPhotosResult {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];  
    return [PHAsset fetchAssetsWithMediaType:self.mediaType options:options];
}

- (BOOL)canSelect {
    if (_minNumberOfSelection >= _maxNumberOfSelection) {
        return NO;
    }
    
    if (_selectedArray.count >= _maxNumberOfSelection) {
        return NO;
    }
    
    return YES;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.asset = [_fetchResult objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.frame.size.width - (_columnNumber - 1) * _spacing)/_columnNumber;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(8, 0, 8, 0);
}


#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self canSelect];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = [_fetchResult objectAtIndex:indexPath.row];
    [_selectedArray addObject:asset];
    _bottomView.assets = _selectedArray;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = [_fetchResult objectAtIndex:indexPath.row];
    [_selectedArray removeObject:asset];
    _bottomView.assets = _selectedArray;
}

#pragma mark ----- delegate 

- (void)bottomContainerSure {
    
}

@end