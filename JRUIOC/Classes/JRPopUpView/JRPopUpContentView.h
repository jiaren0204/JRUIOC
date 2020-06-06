//
//  JRPopUpContentView.h
//  JRPopUpContentView
//
//  Created by 嘉仁 on 2016/10/27.
//  Copyright © 2016年 嘉仁. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JRPopUpContentView : UIView

- (void)setupConfig;

/** 设置尺寸 */
- (CGSize)viewSize;

- (CGPoint)customPoint;

/** 设置中心点(默认是屏幕中点) */
- (CGPoint)customCenter;



@end
