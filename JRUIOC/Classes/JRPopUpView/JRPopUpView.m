//
//  PopUpView.m
//  弹出框Demo
//
//  Created by  梁嘉仁 on 15/11/8.
//  Copyright © 2015年  梁嘉仁. All rights reserved.
//

#import "JRPopUpView.h"
#import "UIView+JRUIOC.h"

@interface JRPopUpView ()

/** 遮挡板 */
@property (nonatomic, strong) UIButton *backgroundView;

@property (nonatomic, strong) UIView *containerView;
/** 展示的内容View */
@property (nonatomic, strong) JRPopUpContentView *contentView;
/** 弹框属性 */
@property (nonatomic, strong) JRPopAttributes *attri;
/** 动画状态 */
@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, copy) void (^statusblock)(BOOL isPresent);
@property (nonatomic, copy) void (^statusblockWithAnim)(BOOL isPresent);

@property (nonatomic, assign) BOOL yDidChanged;

@end

@implementation JRPopUpView

#pragma mark - 初始状态设置
- (UIButton *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIButton alloc] init];
//        _backgroundView.alpha = 0;
        _backgroundView.adjustsImageWhenHighlighted = NO;
        [_backgroundView addTarget:self action:@selector(backgroundViewClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

+ (void)dismissAllContentViewWithContainer:(UIView *)containerView animated:(BOOL)animated
{
    for (UIView *view in containerView.subviews) {
        if ([view isKindOfClass:[JRPopUpView class]]) {
            JRPopUpView *popUp = (JRPopUpView *)view;
            [popUp dismiss:animated completion:^{}];
        }
    }
}

+ (void)dismissWithContainer:(UIView *)containerView targetClass:(Class)targetClass animated:(BOOL)animated
{
    for (UIView *view in containerView.subviews) {
        if ([view isKindOfClass:[JRPopUpView class]]) {
            JRPopUpView *popUp = (JRPopUpView *)view;
            if ([popUp.contentView isKindOfClass:targetClass]) {
                [popUp dismiss:animated completion:^{}];
            }
        }
    }
}

+ (instancetype)popUpWithContentView:(JRPopUpContentView *)contentView attri:(JRPopAttributes *)attri
{
    JRPopUpView *popUpView = [[JRPopUpView alloc] initWithFrame:attri.containerView.bounds];
    popUpView.contentView = contentView;
    popUpView.containerView = attri.containerView;
    popUpView.attri = attri;
    popUpView.isAnimating = NO;
    
    [popUpView setupConfig];
    [popUpView setupFrame];
    
    [attri.animator setup:contentView backgroundView:popUpView.backgroundView containerView:attri.containerView];
    
    return popUpView;
}

- (void)setupFrame
{
    _contentView.size = [self.contentView viewSize];

    switch (self.attri.appearType) {
        case JRPopUpAppearTypeTop: {
            _contentView.centerX = _containerView.width * 0.5;
            _contentView.y = 0;
            break;
        }
        case JRPopUpAppearTypeCenter: {
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            _contentView.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.5);
            break;
        }
        case JRPopUpAppearTypeBottom: {
            _contentView.centerX = _containerView.width * 0.5;
            _contentView.y = _containerView.height - _contentView.height;
            break;
        }
        case JRPopUpAppearTypeCustomCenter: {
            _contentView.center = [self.contentView customCenter];
            break;
        }
        case JRPopUpAppearTypeCustomPoint: {
            CGPoint oriP = [self.contentView customPoint];
            _contentView.x = oriP.x;
            _contentView.y = oriP.y;
        }
    }
}

- (void)setupConfig
{
    self.backgroundView.backgroundColor = _attri.bgColor;
    self.backgroundView.userInteractionEnabled = _attri.isDismissible;
    
    [self addSubview:self.backgroundView];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 控件布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
}

- (void)observeStatusChanged:(void(^)(BOOL isPresent))statusblock
{
    self.statusblock = statusblock;
}

- (void)observeStatusChangedWithAnim:(void(^)(BOOL isPresent))statusblock
{
    self.statusblockWithAnim = statusblock;
}

- (void)checkAddPopUpView
{
    for (UIView *view in self.containerView.subviews) {
        if ([view isEqual:self]) {
            JRPopUpView *popUp = (JRPopUpView *)view;
            [popUp dismiss:YES completion:^{

            }];
        }
        
        if ([view isKindOfClass:[JRPopUpView class]]) {
            JRPopUpView *popUp = (JRPopUpView *)view;
            [popUp removeFromSuperview];
            [popUp dismiss:YES completion:nil];
        }
    }
}

- (void)display:(BOOL)animated completion:(void(^)(void))completion
{
    if (_attri.dismissExistViews) {
        [self checkAddPopUpView];
    }

    if (_isAnimating) { return; }
    
    _isAnimating = YES;
    [self addSubview:self.contentView];
    [_containerView addSubview:self];
    
    if (self.statusblock) {
        self.statusblock(YES);
    }
    
    __weak typeof(self) weakSelf = self;
    [_attri.animator display:_contentView backgroundView:_backgroundView animated:animated completion:^{
        weakSelf.isAnimating = NO;
        if (completion) { completion(); }
        if (weakSelf.statusblockWithAnim) {
            weakSelf.statusblockWithAnim(YES);
        }
    }];
}

#pragma 移除
- (void)dismiss:(BOOL)animated completion:(void(^)(void))completion
{
    if (_isAnimating) { return; }
    
    _isAnimating = YES;
    
    if (self.statusblock) {
        self.statusblock(NO);
    }

    __weak typeof(self) weakSelf = self;
    [_attri.animator dismiss:_contentView backgroundView:_backgroundView animated:animated completion:^{
        weakSelf.isAnimating = NO;

        if (completion) { completion(); }

        [weakSelf.contentView removeFromSuperview];
        [weakSelf removeFromSuperview];
        
        if (weakSelf.statusblockWithAnim) {
            weakSelf.statusblockWithAnim(NO);
        }
    }];
}

- (void)dismiss:(BOOL)animated after:(NSTimeInterval)after completion:(void(^)(void))completion
{
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:after repeats:NO block:^(NSTimer * _Nonnull timer) {
        [weakSelf dismiss:animated completion:completion];
    }];
}

- (void)backgroundViewClicked
{
    [self dismiss:YES completion:nil];
}

#pragma mark - 键盘变化
- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect keyboardFrameEnd = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrameEnd.origin.y;

    if (keyboardFrameEnd.size.height > 200) {
        self.yDidChanged = YES;
        [UIView animateWithDuration:0.25 animations:^{
            if (self.attri.appearType == JRPopUpAppearTypeBottom) {
                
                self.contentView.y = [UIScreen mainScreen].bounds.size.height - self.contentView.height - keyboardFrameEnd.size.height;
            } else {
                self.contentView.y = self.contentView.y + keyboardY - CGRectGetMaxY(self.contentView.frame) - 20;
            }
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    if (self.yDidChanged) {
        self.yDidChanged = NO;
        [UIView animateWithDuration:0.25 animations:^{
            if (self.attri.appearType == JRPopUpAppearTypeBottom) {
                self.contentView.centerX = self.width * 0.5;
                self.contentView.y = [UIScreen mainScreen].bounds.size.height - self.contentView.height;
            } else {
//                self.contentView.centerY = [self.contentView customOrigin].y;
            }
        }];
    }
}

#pragma mark - 点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentView endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
