//
//  JRCollectionReusableView.h
//  JRCollectionView
//
//  Created by 嘉仁 on 16/9/1.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRCollectionViewHeaderFooterItem.h"

@interface JRCollectionHeaderFooterView : UICollectionReusableView

@property (nonatomic, strong) JRCollectionViewHeaderFooterItem *item;

- (void)setupConfig;
- (void)update:(JRCollectionViewHeaderFooterItem *)item;

- (void)performHeaderFooterEventWithName:(NSString *)name;
- (void)performHeaderFooterEventWithName:(NSString *)name msg:(id)msg;

@end
