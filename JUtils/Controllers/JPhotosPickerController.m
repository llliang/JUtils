//
//  JPhotosPickerController.m
//  ImagesPickerController
//
//  Created by Neo on 2017/5/16.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#import "JPhotosPickerController.h"


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

@interface PhotosBottomContainerView : UIView {
    UIScrollView *_scrollView;
    UILabel *_noDataLabel;
    UIButton *_sureButton;
}

@property (nonatomic, strong) NSArray *assets;

@end

@implementation PhotosBottomContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    }
    return self;
}

@end

#pragma mark ------------ separator -------------

@interface PhotosCollectionViewCell : UICollectionViewCell {
    UIImageView *_imageView;
    UIImageView *_markedImageView; // 标记选择或者未选择
}

@property (nonatomic, strong) PHAsset *asset;

@end

@implementation PhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        
        _markedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 5 - 15, 5, 15, 15)];
//        _markedImageView.image = [UIImage imageNamed:@""];
        _markedImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_markedImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
//        _markedImageView.image = [UIImage imageNamed:@""];
        _markedImageView.backgroundColor = [UIColor redColor];
    } else {
//        _markedImageView.image = [UIImage imageNamed:@""];
        _markedImageView.backgroundColor = [UIColor grayColor];
    }
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

@interface JPhotosPickerController () <UICollectionViewDelegateFlowLayout> {
    PHFetchResult *_fetchResult;
    
    NSMutableArray *_selectedArray;
}

@end

@implementation JPhotosPickerController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    self = [super initWithCollectionViewLayout:[[PhotosAssetsCollectionViewLayout alloc] init]];
    if (self) {
        _fetchResult = [self getPhotosResult];
        _spacing = 5;
        _columnNumber = 4;
        
        _selectedArray = [NSMutableArray array];
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
                forCellWithReuseIdentifier:@"AssetsCell"];
        self.collectionView.allowsMultipleSelection = YES;
        
        self.collectionView.alwaysBounceVertical = YES;
        if (self.collectionView.contentSize.height <= self.collectionView.frame.size.height) {
            [self.collectionView setContentSize:CGSizeMake(self.collectionView.contentSize.width, self.collectionView.contentSize.height+1)];
        }
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height - 40);
    }
    
    return self;
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

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self canSelect];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = [_fetchResult objectAtIndex:indexPath.row];
    [_selectedArray addObject:asset];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = [_fetchResult objectAtIndex:indexPath.row];
    [_selectedArray removeObject:asset];
}

@end
