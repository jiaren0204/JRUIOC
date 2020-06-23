//
//  JRCollectionViewItem.h
//  JRCollectionView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define JR_COLLECT_ITEM_CONVERT(itemName) itemName *item = (itemName *)self.item;
#define JR_COLLECT_ITEM_CONVERT_SELF(itemName, self) itemName *item = (itemName *)self.item;

@class JRCollectionViewManager, JRCollectionViewSection;

NS_ASSUME_NONNULL_BEGIN

@interface JRCollectionViewItem : NSObject

@property (nonatomic, weak) JRCollectionViewManager *manager;
@property (nonatomic, weak) JRCollectionViewSection *section;

@property (nonatomic, copy, readonly) NSString *cellIdentifier;
@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong, readonly) NSIndexPath *indexPath;


+ (instancetype)itemWithCellClass:(Class)cellClass cellSize:(CGSize)cellSize;
- (instancetype)initWithCellClass:(Class)cellClass cellSize:(CGSize)cellSize;

- (void)setupConfig;


@end

NS_ASSUME_NONNULL_END
