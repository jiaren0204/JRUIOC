//
//  JRPopUpContentView.m
//  JRPopUpContentView
//
//  Created by 嘉仁 on 2016/10/27.
//  Copyright © 2016年 嘉仁. All rights reserved.
//

#import "JRPopUpContentView.h"


@implementation JRPopUpContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupConfig];
}


- (void)setupConfig{}

/** 设置尺寸 */
- (CGSize)viewSize
{
    return self.frame.size;
}

- (CGPoint)customPoint
{
    return CGPointZero;
}

- (CGPoint)customCenter
{
    return CGPointZero;
}


@end
