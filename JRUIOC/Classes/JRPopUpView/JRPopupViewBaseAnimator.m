//
//  JRPopupViewBaseAnimator.m
//  JRPopUpView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import "JRPopupViewBaseAnimator.h"
#import "UIView+JRUIOC.h"

@interface JRPopupViewBaseAnimator()

@end

@implementation JRPopupViewBaseAnimator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.displayDuration = 0.25;
        self.displayAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
    }
    return self;
}

- (void)setup:(UIView *)contentView backgroundView:(UIButton *)backgroundView containerView:(UIView *)containerView
{

}

- (void)display:(UIView *)contentView backgroundView:(UIButton *)backgroundView animated:(BOOL)animated completion:(void(^)(void))completion
{
    if (animated) {
        [UIView animateWithDuration:_displayDuration delay:0 options:_displayAnimationOptions animations:^{
            if (self.displayAnimateBlock) {
                self.displayAnimateBlock();
            }
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    } else {
        if (self.displayAnimateBlock) {
            self.displayAnimateBlock();
        }
        if (completion) {
            completion();
        }
    }
}

- (void)dismiss:(UIView *)contentView backgroundView:(UIButton *)backgroundView animated:(BOOL)animated completion:(void(^)(void))completion
{
    if (animated) {
        [UIView animateWithDuration:_displayDuration delay:0 options:_displayAnimationOptions animations:^{
            if (self.dismissAnimateBlock) {
                self.dismissAnimateBlock();
            }
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    } else {
        if (self.dismissAnimateBlock) {
            self.dismissAnimateBlock();
        }
        if (completion) {
            completion();
        }
    }
}

@end

@implementation JRPopupViewAlphaAnimator
- (void)setup:(UIView *)contentView backgroundView:(UIButton *)backgroundView containerView:(UIView *)containerView
{
    backgroundView.alpha = 0;
    contentView.alpha = 0;
    
    self.displayAnimateBlock = ^{
        contentView.alpha = 1;
        backgroundView.alpha = 1;
    };
    
    self.dismissAnimateBlock = ^{
        contentView.alpha = 0;
        backgroundView.alpha = 0;
    };
}
@end

@implementation JRPopupViewTopAnimator
- (void)setup:(UIView *)contentView backgroundView:(UIButton *)backgroundView containerView:(UIView *)containerView
{
    backgroundView.alpha = 0;
    contentView.y = -contentView.height;
    
    self.displayAnimateBlock = ^{
        contentView.transform = CGAffineTransformMakeTranslation(0, contentView.height);
        backgroundView.alpha = 1;
    };
    
    self.dismissAnimateBlock = ^{
        contentView.transform = CGAffineTransformMakeTranslation(0, -contentView.height);
        backgroundView.alpha = 0;
    };
}
@end

@implementation JRPopupViewBottomAnimator
- (void)setup:(UIView *)contentView backgroundView:(UIButton *)backgroundView containerView:(UIView *)containerView
{
    contentView.y = containerView.height;
    backgroundView.alpha = 0;
    self.displayAnimateBlock = ^{
        contentView.transform = CGAffineTransformMakeTranslation(0, -contentView.height);
        backgroundView.alpha = 1;
    };
    
    self.dismissAnimateBlock = ^{
        contentView.transform = CGAffineTransformMakeTranslation(0, contentView.height);
        backgroundView.alpha = 0;
    };
}
@end

#pragma mark - 执行动画
//- (void)performPopUpAnimationTypeNormal
//{
//    self.alpha = 0;
//    [UIView animateWithDuration:kTransitionDuration animations:^{
//        self.alpha = 1;
//    }];
//}
//
//- (void)performPopUpAnimationTypeBounds
//{
//    [UIView animateWithDuration:kTransitionDuration * 0.5 animations:^{
//        self.baseView.transform = CGAffineTransformMakeScale(1.09, 1.09);
//    }];
//    [UIView animateWithDuration:kTransitionDuration * 0.35 delay:kTransitionDuration * 0.5 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.baseView.transform = CGAffineTransformMakeScale(0.93, 0.93);
//    } completion:nil];
//    [UIView animateWithDuration:kTransitionDuration * 0.2 delay:kTransitionDuration * 0.85 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.baseView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    } completion:nil];
//}
//
//- (void)performPopUpAnimationTypeZoomOut
//{
//    self.baseView.transform = CGAffineTransformMakeScale(1.4, 1.4);
//    [UIView animateKeyframesWithDuration:kTransitionDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
//        self.baseView.transform = CGAffineTransformMakeScale(1, 1);
//    } completion:nil];
//}
//
//// 从底部出现
//- (void)performPopUpAnimationTypeBottom
//{
//    self.coverBtn.alpha = 0;
//    [UIView animateWithDuration:kTransitionDuration animations:^{
//        self.coverBtn.alpha = 1;
//        self.baseView.transform = CGAffineTransformTranslate(self.baseView.transform, 0, -self.baseView.height);
//    }];
//}
//
//// 从头部部出现
//- (void)performPopUpAnimationTypeTop
//{
//    self.coverBtn.alpha = 0;
//    [UIView animateWithDuration:kTransitionDuration animations:^{
//        self.coverBtn.alpha = 1;
//        self.baseView.transform = CGAffineTransformTranslate(self.baseView.transform, 0, self.baseView.height);
//    }];
//}
