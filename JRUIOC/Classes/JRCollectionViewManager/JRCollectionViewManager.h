//
//  JRCollectionViewManager.h
//  JRCollectionView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRCollectionViewItem.h"
#import "JRCollectionViewSection.h"
#import "JRCustomSizeLayout.h"
#import "JRCollectionViewCell.h"
#import "JRCollectionHeaderFooterView.h"


typedef void(^JRCollectionViewManagerCellEventBlock)(JRCollectionViewItem *item, id msg);
typedef void(^JRCollectionViewManagerHeaderFooterEventBlock)(JRCollectionViewHeaderFooterItem *item, id msg);

@interface JRCollectionViewManager : NSObject

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<JRCollectionViewSection *> *sections;

+ (instancetype)createWithCollectionView:(UICollectionView *)collectionView
                             cellClasses:(NSArray<Class> *)cellClasses;

+ (instancetype)createWithCollectionView:(UICollectionView *)collectionView
                             cellClasses:(NSArray<Class> *)cellClasses
                           headerClasses:(NSArray<Class> *)headerClasses;

+ (instancetype)createWithCollectionView:(UICollectionView *)collectionView
                             cellClasses:(NSArray<Class> *)cellClasses
                           footerClasses:(NSArray<Class> *)footerClasses;

+ (instancetype)createWithCollectionView:(UICollectionView *)collectionView
                             cellClasses:(NSArray<Class> *)cellClasses
                           headerClasses:(NSArray<Class> *)headerClasses
                           footerClasses:(NSArray<Class> *)footerClasses;

@property (nonatomic, copy) void (^didEndScrollingCallback)(JRCollectionViewItem *item, NSInteger row);

- (void)add:(JRCollectionViewSection *)section;
- (void)remove:(JRCollectionViewSection *)section;
- (void)removeAllSections;
- (void)reload;


- (void)registerDidEndScrollingEvent:(void(^)(JRCollectionViewItem *item, NSInteger row))callback;

- (void)registerCellEventWithName:(NSString *)name block:(JRCollectionViewManagerCellEventBlock)block;

- (void)performCellEventWithName:(NSString *)name item:(JRCollectionViewItem *)item msg:(id)msg;

- (void)registerHeaderFooterEventWithName:(NSString *)name block:(JRCollectionViewManagerHeaderFooterEventBlock)block;

- (void)performHeaderFooterEventWithName:(NSString *)name item:(JRCollectionViewHeaderFooterItem *)item msg:(id)msg;

@end


