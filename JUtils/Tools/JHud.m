//
//  JHud.m
//  Gogenius
//
//  Created by Neo on 2017/4/5.
//  Copyright © 2017年 Gogenius. All rights reserved.
//

#import "JHud.h"
#import "UIColor+hex.h"
#import "UIView+frame.h"
#import "NSString+size.h"

static const CGFloat kDefaultTime = 2.0f;
static const CGFloat kDefaultHudWidth = 180.0f;
static const CGFloat kImageHeight = 50.0f;

@interface JHud (){
    
    UIView *_containerView;
    UIWindow *_window;
    UIControl *_overlayView;
    JHudView *_hudView;  
}

@end

@implementation JHud

- (instancetype)init {
    self = [super init];
    if (self) {
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate respondsToSelector:@selector(window)]) {
            _window = [delegate performSelector:@selector(window)];
        } else {
            _window = [[UIApplication sharedApplication] keyWindow];
        }
    }
    return self;
}

#pragma mark ---- Class method

+ (JHud *)instance {
    static dispatch_once_t once;
    static JHud *hudInstance = nil;
    dispatch_once(&once, ^{
        hudInstance = [[JHud alloc] init];
    });
    return hudInstance;
}

+ (void)showContent:(NSString *)content {
    [JHud showImage:nil content:content withTime:kDefaultTime needLock:NO inView:nil];
}

+ (void)showContent:(NSString *)content needLock:(BOOL)lock {
    [JHud showImage:nil content:content withTime:kDefaultTime needLock:lock inView:nil];
}

+ (void)showContent:(NSString *)content withTime:(CGFloat)time {
    [JHud showImage:nil content:content withTime:time needLock:NO inView:nil];
}

+ (void)showContent:(NSString *)content withTime:(CGFloat)time inView:(UIView *)view {
    [JHud showImage:nil content:content withTime:time needLock:NO inView:view];
}

+ (void)showImage:(UIImage *)image {
    [JHud showImage:image content:nil withTime:kDefaultTime needLock:NO inView:nil];
}

+ (void)showImage:(UIImage *)image content:(NSString *)content withTime:(CGFloat)time {
    [JHud showImage:image content:content withTime:time needLock:NO inView:nil];
}

+ (void)showImage:(UIImage *)image content:(NSString *)content withTime:(CGFloat)time inView:(UIView *)view{
    [JHud showImage:image content:content withTime:time needLock:NO inView:view];
}

+ (void)showImage:(UIImage *)image content:(NSString *)content needLock:(BOOL)lock inView:(UIView *)view {
    [JHud showImage:image content:content withTime:0 needLock:lock inView:view];
}

+ (void)showImage:(UIImage *)image content:(NSString *)content withTime:(CGFloat)time needLock:(BOOL)lock inView:(UIView *)view {
    [[JHud instance] showImage:image content:content activity:NO withTime:time needLock:lock inView:view];
}

+ (void)showActivityIndicatorInView:(UIView *)view needLock:(BOOL)lock {
    [[JHud instance] showImage:nil content:nil activity:YES withTime:0 needLock:lock inView:nil];
}

+ (void)dismiss {
    [[JHud instance] hudHide];
}

#pragma private

- (void)showImage:(UIImage *)image content:(NSString *)content activity:(BOOL)activity withTime:(CGFloat)time needLock:(BOOL)lock inView:(UIView *)view {
    
    NSAssert(time >= 0, @"时间不能小于0");    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (view) {
        _containerView = view;
    } else {
        _containerView = _window;
    }
    if (lock) {
        if (![_containerView.subviews containsObject:self.overlayView]) {
            [_containerView addSubview:self.overlayView];
        }
    } else {
        [_overlayView removeFromSuperview];
    }
    if (![_containerView.subviews containsObject:self.hudView]) {
        [_containerView addSubview:self.hudView];
    }
    [self.hudView layoutWith:image content:content activity:activity];
    self.hudView.center = _containerView.center;
    
    [self hudShow];
    if (!lock) {
        [self performSelector:@selector(hudHide) withObject:nil afterDelay:time];
    }
}

- (UIControl *)overlayView {
    CGRect frame = [UIScreen mainScreen].bounds;
    if (!_overlayView) {
        _overlayView = [[UIControl alloc] init];
        _overlayView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
        _overlayView.alpha = 0;
    }
    _overlayView.frame = frame;
    return _overlayView;
}

- (JHudView *)hudView {
    if (!_hudView) {
        _hudView = [[JHudView alloc] init];
    }
    return _hudView;
}

- (void)dismiss {
    [self hudHide];
}

- (void)hudShow {
    self.hudView.alpha = 0;
    NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
    
    [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
        _hudView.alpha = 1;
        _overlayView.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
}

- (void)hudHide {
    NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
    [UIView animateWithDuration:0.15 delay:0 options:options animations:^{
        _hudView.alpha = 0;
        _overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        [_hudView removeFromSuperview];
        _hudView = nil;
    }];
}

@end

#pragma mark -------

@interface JHudView () {
    UIImageView             *_hudImageView;
    UILabel                 *_hudContentLabel;
    UIActivityIndicatorView *_hudIndicatorView;
    UIFont                  *_font;
}

@end


@implementation JHudView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.cornerRadius = 5;
        
        UIColor *hudFontColor = [UIColor whiteColor];
        _font = [UIFont systemFontOfSize:12];
        
        _hudImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kImageHeight, kImageHeight)];
        _hudImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_hudImageView];
        
        _hudContentLabel = UILabel.new;
        [_hudContentLabel setTextColor:hudFontColor];
        _hudContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _hudContentLabel.font = _font;
        _hudContentLabel.textAlignment = NSTextAlignmentCenter;
        _hudContentLabel.numberOfLines = 0;
        _hudContentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_hudContentLabel];
        
        _hudIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _hudIndicatorView.color = hudFontColor;
        _hudIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_hudIndicatorView];
        
        self.width = kDefaultHudWidth;
    }
    return  self;
}

- (void)layoutWith:(UIImage *)image content:(NSString *)content activity:(BOOL)activity {
    if (image != nil && activity) {
        NSAssert(NO, @"图片和菊花不能同时存在");
    }
    //当都为空时，显示无限菊花
    CGSize contentSize = CGSizeZero;
    if (content && content.length != 0) {
        _hudContentLabel.text = content;
        contentSize = [content sizeWithFont:_font constrainedToSize:CGSizeMake(kDefaultHudWidth - 30, MAXFLOAT)];
    }
    self.width = kDefaultHudWidth;
    if (image) {
        _hudImageView.hidden = NO;
        _hudIndicatorView.hidden = YES;
        _hudImageView.image = image;
        _hudImageView.center = CGPointMake(kDefaultHudWidth/2, 15 + _hudImageView.height/2);
        
        _hudContentLabel.top = _hudImageView.bottom + 15;
    }else if (activity) {
        _hudIndicatorView.hidden = NO;
        [_hudIndicatorView startAnimating];
        _hudImageView.hidden = YES;
        
        // 调整下宽度
        if (content == nil || content.length == 0) {
            self.width = 60 + _hudIndicatorView.height;
            _hudIndicatorView.center = CGPointMake(self.width/2, 30+_hudIndicatorView.height/2);
        } else {
            _hudIndicatorView.center = CGPointMake(self.width/2, 15+_hudIndicatorView.height/2);   
        }
        _hudContentLabel.top = _hudIndicatorView.bottom + 15;
    } else {
        _hudImageView.hidden = _hudIndicatorView.hidden = YES;
        _hudContentLabel.top = 15;
    }
    _hudContentLabel.height = contentSize.height;
    _hudContentLabel.width = kDefaultHudWidth - 30;
    _hudContentLabel.left = 15;
    
    self.height = _hudContentLabel.bottom + 15;
}

@end

