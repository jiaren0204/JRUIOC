//
//  JRCollectionViewSection.m
//  JRCollectionView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import "JRCollectionViewSection.h"
#import "JRCollectionViewManager.h"
#import "JRCollectionViewItem.h"
#import "JRCollectionViewHeaderFooterItem.h"

@implementation JRCollectionViewSection

- (NSMutableArray<JRCollectionViewItem *> *)items
{
    if (_items == nil) {
        _items = [NSMutableArray new];
    }
    return _items;
}

- (NSUInteger)index
{
    return [_manager.sections indexOfObject:self];
}

- (void)setHeaderItem:(JRCollectionViewHeaderFooterItem *)headerItem
{
    headerItem.manager = _manager;
    
    headerItem.section = self;
    _headerItem = headerItem;
}

- (void)setFootererItem:(JRCollectionViewHeaderFooterItem *)footererItem
{
    footererItem.manager = _manager;
    footererItem.section = self;
    _footererItem = footererItem;
}

- (void)add:(JRCollectionViewItem *)item
{
    item.section = self;
    item.manager = _manager;
    
    [self.items addObject:item];
}

- (void)remove:(JRCollectionViewItem *)item
{
    [self.items removeObject:item];
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
}


- (void)insertItem:(JRCollectionViewItem *)item afterItem:(JRCollectionViewItem *)afterItem
{
    if ([self.items containsObject:afterItem] == NO) {
        NSLog(@"can't insert because afterItem did not in sections");
        return;
    }
    
    item.section = self;
    item.manager = _manager;
    
    [self.items insertObject:item atIndex:[self.items indexOfObject:afterItem] + 1];
    [_manager insertItemsAtIndexPaths:@[item.indexPath]];
}

- (void)insertItems:(NSArray<JRCollectionViewItem *> *)items afterItem:(JRCollectionViewItem *)afterItem
{
    if ([self.items containsObject:afterItem] == NO) {
        NSLog(@"can't insert because afterItem did not in sections");
        return;
    }
    
    NSUInteger newFirstIndex = [self.items indexOfObject:afterItem] + 1;
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray new];
    
    for (int i = 0; i < self.items.count; i++) {
        JRCollectionViewItem *item = self.items[i];
        item.section = self;
        item.manager = _manager;
        [indexPaths addObject:[NSIndexPath indexPathForRow:(newFirstIndex + i) inSection:afterItem.indexPath.section]];
    }
    
    [_manager insertItemsAtIndexPaths:indexPaths];
}

- (void)deleteItems:(NSArray<JRCollectionViewItem *> *)items
{
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray new];

    for (JRCollectionViewItem *item in items) {
        [indexPaths addObject:item.indexPath];
    }
    
    [self.items removeObjectsInArray:items];
    
    [_manager deleteItemsAtIndexPaths:indexPaths];
}

- (void)reload
{
    if ([_manager.sections containsObject:self]) {
        [_manager reloadSections:[NSIndexSet indexSetWithIndex:self.index]];
    }
}

- (void)reloadItems:(NSArray<JRCollectionViewItem *> *)items
{
    if ([_manager.sections containsObject:self]) {
        
        NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray new];
        for (JRCollectionViewItem *item in items) {
            NSUInteger index = [self.items indexOfObject:item];
            [indexPaths addObject:[NSIndexPath indexPathForItem:index inSection:self.index]];
        }

        [_manager reloadItemsAtIndexPaths:indexPaths];
    }
}


@end
