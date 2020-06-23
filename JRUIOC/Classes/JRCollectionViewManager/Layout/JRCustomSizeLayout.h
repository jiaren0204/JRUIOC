//
//  JRCollectionViewLayout.h
//  JRCollectionView
//
//  Created by 嘉仁 on 16/8/30.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

/// 使用 JRCustomSizeLayout ,处理数据使用JRCollectionViewManager和JRCollectionViewSection
/// 不要直接使用collectionView处理

#import <UIKit/UIKit.h>

@class JRCollectionViewManager;

@interface JRCustomSizeLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) JRCollectionViewManager *manager;


@end
