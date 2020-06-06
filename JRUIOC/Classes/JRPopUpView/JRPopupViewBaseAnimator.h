//
//  JRPopupViewBaseAnimator.h
//  JRPopUpView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRPopupViewBaseAnimator : NSObject

- (void)setup:(UIView *)contentView backgroundView:(UIButton *)backgroundView containerView:(UIView *)containerView;

- (void)display:(UIView *)contentView backgroundView:(UIButton *)backgroundView animated:(BOOL)animated completion:(void(^)(void))completion;

- (void)dismiss:(UIView *)contentView backgroundView:(UIButton *)backgroundView animated:(BOOL)animated completion:(void(^)(void))completion;

@property (nonatomic, assign) NSTimeInterval displayDuration;
@property (nonatomic, assign) UIViewAnimationOptions displayAnimationOptions;

@property (nonatomic, copy) void (^displayAnimateBlock)(void);
@property (nonatomic, copy) void (^dismissAnimateBlock)(void);

@end


@interface JRPopupViewAlphaAnimator : JRPopupViewBaseAnimator

@end

@interface JRPopupViewTopAnimator : JRPopupViewBaseAnimator

@end

@interface JRPopupViewBottomAnimator : JRPopupViewBaseAnimator

@end

NS_ASSUME_NONNULL_END
