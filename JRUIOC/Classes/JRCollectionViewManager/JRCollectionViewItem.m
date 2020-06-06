//
//  JRCollectionViewItem.m
//  JRCollectionView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import "JRCollectionViewItem.h"
#import "JRCollectionViewManager.h"
#import "JRCollectionViewSection.h"

@implementation JRCollectionViewItem

- (instancetype)initWithCellClass:(Class)cellClass cellSize:(CGSize)cellSize
{
    self = [super init];
    if (self) {
        self->_cellSize = cellSize;
        self->_cellIdentifier = NSStringFromClass(cellClass);

//        [self setupConfig];
    }
    return self;
}

+ (instancetype)itemWithCellClass:(Class)cellClass cellSize:(CGSize)cellSize
{
    return [[self alloc] initWithCellClass:cellClass cellSize:cellSize];
}

- (void)setCellSize:(CGSize)cellSize
{
    _cellSize = cellSize;
}

- (NSIndexPath *)indexPath
{
    NSUInteger row = [_section.items indexOfObject:self];
    NSUInteger section = [_manager.sections indexOfObject:_section];
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)setupConfig
{
    
}

- (void)reload
{
    [_manager.collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
//    [_manager.collectionView performBatchUpdates:<#^(void)updates#> completion:<#^(BOOL finished)completion#>]
}

- (void)remove
{
    if (_manager == nil || _section == nil) {
        NSLog(@"Item did not in section or manager，please check section add method");
        return;
    }
    
    if ([_section.items containsObject:self] == NO) {
        NSLog(@"can't delete because this item did not in section");
        return;
    }
    
    NSIndexPath *indexPath = self.indexPath;
    [_section.items removeObject:self];
    [_manager.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}


@end
