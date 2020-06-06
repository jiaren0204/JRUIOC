//
//  UIView+JRUIOC.h
//  JRUIOC
//
//  Created by 梁嘉仁 on 2020/6/6.
//  Copyright © 2020 jiaren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JRUIOC)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;

@end

NS_ASSUME_NONNULL_END
