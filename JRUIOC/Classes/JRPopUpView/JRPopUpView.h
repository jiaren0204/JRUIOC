//
//  PopUpView.h
//
//  Created by  梁嘉仁 on 15/11/8.
//  Copyright © 2015年  梁嘉仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRPopUpContentView.h"
#import "JRPopAttributes.h"


@interface JRPopUpView : UIView

+ (instancetype)popUpWithContentView:(JRPopUpContentView *)contentView attri:(JRPopAttributes *)attri;


/// 关闭所有的弹框
/// @param containerView JRPopAttributes -> containerView
+ (void)dismissAllContentViewWithContainer:(UIView *)containerView animated:(BOOL)animated;


/// 关闭指定的类的弹出框
/// @param containerView JRPopAttributes -> containerView
/// @param targetClass 弹出框的类
+ (void)dismissWithContainer:(UIView *)containerView targetClass:(Class)targetClass animated:(BOOL)animated;


/// 监听方法
- (void)observeStatusChanged:(void(^)(BOOL isPresent))statusblock;
- (void)observeStatusChangedWithAnim:(void(^)(BOOL isPresent))statusblock;

- (void)display:(BOOL)animated completion:(void(^)(void))completion;
- (void)dismiss:(BOOL)animated completion:(void(^)(void))completion;
- (void)dismiss:(BOOL)animated after:(NSTimeInterval)after completion:(void(^)(void))completion;

@end
