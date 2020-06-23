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

typedef NS_ENUM(NSInteger, JR_CollectionViewEvent) {
    JR_CollectionViewEventReloadData = 0,
    JR_CollectionViewEventDataDidChanged
};


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

/// 数据源处理
- (void)add:(JRCollectionViewSection *)section;
- (void)remove:(JRCollectionViewSection *)section;
- (void)removeAllSections;

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)insertSections:(NSIndexSet *)sections;
- (void)deleteSections:(NSIndexSet *)sections;
- (void)reloadSections:(NSIndexSet *)sections;
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;
- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)reload;

// 系统事件处理
- (void)addCollectionEventListenerWithId:(id)Id name:(JR_CollectionViewEvent)name block:(void(^)(void))block;
- (void)removeCollectionEventWithId:(id)Id;


- (void)registerDidEndScrollingEvent:(void(^)(JRCollectionViewItem *item, NSInteger row))callback;

- (void)registerCellEventWithName:(NSString *)name block:(JRCollectionViewManagerCellEventBlock)block;

- (void)performCellEventWithName:(NSString *)name item:(JRCollectionViewItem *)item msg:(id)msg;

- (void)registerHeaderFooterEventWithName:(NSString *)name block:(JRCollectionViewManagerHeaderFooterEventBlock)block;

- (void)performHeaderFooterEventWithName:(NSString *)name item:(JRCollectionViewHeaderFooterItem *)item msg:(id)msg;

@end


