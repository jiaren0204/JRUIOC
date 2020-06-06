//
//  JRCollectionViewManager.m
//  JRCollectionView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import "JRCollectionViewManager.h"

@interface JRCollectionViewManager()<UICollectionViewDataSource, UICollectionViewDelegate>
///** cell事件调用 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, JRCollectionViewManagerCellEventBlock> *cellEventDic;

@property (nonatomic, strong) NSMutableDictionary<NSString *, JRCollectionViewManagerHeaderFooterEventBlock> *headerFooterEventDic;
@end

@implementation JRCollectionViewManager

+ (instancetype)createWithCollectionView:(UICollectionView *)collectionView cellClasses:(NSArray<Class> *)cellClasses
{
    return [self createWithCollectionView:collectionView cellClasses:cellClasses headerClasses:@[] footerClasses:@[]];
}

+ (instancetype)createWithCollectionView:(UICollectionView *)collectionView cellClasses:(NSArray<Class> *)cellClasses headerClasses:(NSArray<Class> *)headerClasses
{
    return [self createWithCollectionView:collectionView cellClasses:cellClasses headerClasses:headerClasses footerClasses:@[]];
}

+ (instancetype)createWithCollectionView:(UICollectionView *)collectionView cellClasses:(NSArray<Class> *)cellClasses footerClasses:(NSArray<Class> *)footerClasses
{
        return [self createWithCollectionView:collectionView cellClasses:cellClasses headerClasses:@[] footerClasses:footerClasses];
}

+ (instancetype)createWithCollectionView:(UICollectionView *)collectionView
                             cellClasses:(NSArray<Class> *)cellClasses
                           headerClasses:(NSArray<Class> *)headerClasses
                           footerClasses:(NSArray<Class> *)footerClasses
{
    JRCollectionViewManager *manager = [JRCollectionViewManager new];
    
    collectionView.delegate = manager;
    collectionView.dataSource = manager;
    collectionView.showsVerticalScrollIndicator = false;
    collectionView.showsHorizontalScrollIndicator = false;
    manager.collectionView = collectionView;
    
    manager.cellEventDic = [NSMutableDictionary new];
    manager.headerFooterEventDic = [NSMutableDictionary new];
    manager.sections = [NSMutableArray new];
    

    if ([collectionView.collectionViewLayout isKindOfClass:[JRCustomSizeLayout class]]) {
        JRCustomSizeLayout *layout = (JRCustomSizeLayout *)collectionView.collectionViewLayout;
        layout.manager = manager;
    }
    
    [cellClasses enumerateObjectsUsingBlock:^(Class  _Nonnull cls, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager registerWithCellClass:cls];
    }];
    
    [headerClasses enumerateObjectsUsingBlock:^(Class  _Nonnull cls, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager registerHeadFootWithHeaderFooterClass:cls kind:UICollectionElementKindSectionHeader];
    }];
    
    [footerClasses enumerateObjectsUsingBlock:^(Class  _Nonnull cls, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager registerHeadFootWithHeaderFooterClass:cls kind:UICollectionElementKindSectionFooter];
    }];
    

    return manager;
}

#pragma mark - 注册
/** 注册cellID */
- (void)registerWithCellClass:(Class)cellClass
{
    NSString *cellName = NSStringFromClass(cellClass);
    if ([self isCreateByNibWithCellName:cellName]) {
        [self.collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:cellName];
    }
    else {
        [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:cellName];
    }
}

/** 注册HeadFootID */
- (void)registerHeadFootWithHeaderFooterClass:(Class)headerFooterClass kind:(NSString *)kind
{
    NSString *headerFooterName = NSStringFromClass(headerFooterClass);
    if ([self isCreateByNibWithCellName:headerFooterName]) {
        [self.collectionView registerNib:[UINib nibWithNibName:headerFooterName bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:headerFooterName];
    }
    else {
        [self.collectionView registerClass:headerFooterClass forSupplementaryViewOfKind:kind withReuseIdentifier:headerFooterName];
    }
}

- (void)add:(JRCollectionViewSection *)section
{
    section.manager = self;
    [self.sections addObject:section];
}

- (void)remove:(JRCollectionViewSection *)section
{
    [self.sections removeObject:section];
}

- (void)removeAllSections
{
    [self.sections removeAllObjects];
}

- (void)reload
{
    [self.collectionView reloadData];
}


#pragma mark - 事件注册&调用
// MARK: 系统
- (void)registerDidEndScrollingEvent:(void(^)(JRCollectionViewItem *item, NSInteger row))callback
{
    self.didEndScrollingCallback = callback;
}

- (void)registerCellEventWithName:(NSString *)name block:(JRCollectionViewManagerCellEventBlock)block
{
    self.cellEventDic[name] = block;
}

- (void)performCellEventWithName:(NSString *)name item:(JRCollectionViewItem *)item msg:(id)msg
{
    JRCollectionViewManagerCellEventBlock callback = self.cellEventDic[name];
    if (callback) {
        callback(item, msg);
    }
}

- (void)registerHeaderFooterEventWithName:(NSString *)name block:(JRCollectionViewManagerHeaderFooterEventBlock)block
{
    self.headerFooterEventDic[name] = block;
}

- (void)performHeaderFooterEventWithName:(NSString *)name item:(JRCollectionViewHeaderFooterItem *)item msg:(id)msg
{
    JRCollectionViewManagerHeaderFooterEventBlock callback = self.headerFooterEventDic[name];
    if (callback) {
        callback(item, msg);
    }
}


#pragma mark - 辅助方法
/** 判断cell是否从XIB读取 */
- (BOOL)isCreateByNibWithCellName:(NSString *)cellName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.nib", cellName]]];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    JRCollectionViewCell *cell = (JRCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell didSelect];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JRCollectionViewCell *cell = (JRCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell didDeselect];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    JRCollectionViewCell *cell = (JRCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell didHighlight];
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    JRCollectionViewCell *cell = (JRCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell didUnhighlight];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JRCollectionViewSection *curSection = self.sections[section];
    return curSection.items.count;;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    JRCollectionViewSection *curSection = self.sections[indexPath.section];
    
    if (curSection.headerItem && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self dequeueHeaderFooterViewWithItem:curSection.headerItem kind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    }
    
    if (curSection.footererItem && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self dequeueHeaderFooterViewWithItem:curSection.footererItem kind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
    }
    
    return nil;
}

/** 注册/找到复用的HeaderFooterView */
- (JRCollectionHeaderFooterView *)dequeueHeaderFooterViewWithItem:(JRCollectionViewHeaderFooterItem *)item kind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    JRCollectionHeaderFooterView *view = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:item.cellIdentifier forIndexPath:indexPath];
    
    view.item = item;
    [view update:item];
    
    return view;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    JRCollectionViewSection *curSection = self.sections[indexPath.section];
    JRCollectionViewItem *item = curSection.items[indexPath.item];
    item.manager = self;
    
    JRCollectionViewCell *cell = (JRCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:item.cellIdentifier forIndexPath:indexPath];
    
    cell.item = item;
    [cell update:item];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.sections.count != 1) { return; }
    
    if (self.didEndScrollingCallback == nil) { return; }
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]] == NO) { return; }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) { return; }
    
    JRCollectionViewSection *section = self.sections.firstObject;
    
    NSInteger row = (NSInteger)(self.collectionView.contentOffset.x / [UIScreen mainScreen].bounds.size.width + 0.5) % section.items.count;
    
    self.didEndScrollingCallback(section.items[row], row);
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
//
//    // 水平方向&Cell是满屏尺寸宽度 才回调
//    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        CGFloat offsetX = self.contentOffset.x;
//        [self eventCall:JR_CollectionViewEventDidScroll model:nil msg:@(offsetX)];
//    }
//}




@end
