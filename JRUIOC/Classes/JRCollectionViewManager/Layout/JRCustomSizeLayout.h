//
//  JRCollectionViewLayout.h
//  JRCollectionView
//
//  Created by 嘉仁 on 16/8/30.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRCollectionViewManager;

@interface JRCustomSizeLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) JRCollectionViewManager *manager;


@end
