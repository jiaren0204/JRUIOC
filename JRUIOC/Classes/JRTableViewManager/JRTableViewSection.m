#import "JRTableViewSection.h"
#import "JRTableViewManager.h"


@implementation JRTableViewSection

- (NSMutableArray<JRTableViewItem *> *)items
{
    if (_items == nil) {
        _items = [NSMutableArray new];
    }
    return _items;
}

- (void)setHeaderItem:(JRTableViewHeaderFooterItem *)headerItem
{
    headerItem.tableViewManager = _tableViewManager;
    
    headerItem.section = self;
    _headerItem = headerItem;
}

- (void)setFooterItem:(JRTableViewHeaderFooterItem *)footerItem
{
    footerItem.tableViewManager = _tableViewManager;
    footerItem.section = self;
    _footerItem = footerItem;
}

- (void)add:(JRTableViewItem *)item
{
    item.section = self;
    item.tableViewManager = _tableViewManager;
    
    [self.items addObject:item];
}

- (void)remove:(JRTableViewItem *)item
{
    [self.items removeObject:item];
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
}

- (void)insertItem:(JRTableViewItem *)item afterItem:(JRTableViewItem *)afterItem
{
    [self insertItem:item afterItem:afterItem animation:UITableViewRowAnimationAutomatic];
}

- (void)insertItem:(JRTableViewItem *)item afterItem:(JRTableViewItem *)afterItem animation:(UITableViewRowAnimation)animation
{
    if ([self.items containsObject:afterItem] == NO) {
        NSLog(@"can't insert because afterItem did not in sections");
        return;
    }
    
    [_tableViewManager.tableView beginUpdates];
    item.section = self;
    item.tableViewManager = _tableViewManager;
    
    [self.items insertObject:item atIndex:[self.items indexOfObject:afterItem] + 1];
    [_tableViewManager.tableView insertRowsAtIndexPaths:@[item.indexPath] withRowAnimation:animation];
    [_tableViewManager.tableView endUpdates];
}

- (void)moveItem:(JRTableViewItem *)item toRow:(NSInteger)toRow
{
    if ([self.items containsObject:item] == NO) {
        NSLog(@"can't move because item did not in sections");
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 11.0, *)) {
        [_tableViewManager.tableView performBatchUpdates:^{
            [weakSelf.tableViewManager.tableView moveRowAtIndexPath:item.indexPath toIndexPath:[NSIndexPath indexPathForRow:toRow inSection:weakSelf.index]];
        } completion:^(BOOL finished) {
            [weakSelf.tableViewManager reload];
        }];
    } else {
        [self.tableViewManager.tableView moveRowAtIndexPath:item.indexPath toIndexPath:[NSIndexPath indexPathForRow:toRow inSection:self.index]];
        [self.tableViewManager reload];
    }

}

- (void)insertItems:(NSArray<JRTableViewItem *> *)items afterItem:(JRTableViewItem *)afterItem
{
    [self insertItems:items afterItem:afterItem animation:UITableViewRowAnimationAutomatic];
}

- (void)insertItems:(NSArray<JRTableViewItem *> *)items afterItem:(JRTableViewItem *)afterItem animation:(UITableViewRowAnimation)animation
{
    if ([self.items containsObject:afterItem] == NO) {
        NSLog(@"can't insert because afterItem did not in sections");
        return;
    }
    
    [_tableViewManager.tableView beginUpdates];
    NSUInteger newFirstIndex = [self.items indexOfObject:afterItem] + 1;
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray new];
    
    for (int i = 0; i < self.items.count; i++) {
        JRTableViewItem *item = self.items[i];
        item.section = self;
        item.tableViewManager = _tableViewManager;
        [indexPaths addObject:[NSIndexPath indexPathForRow:(newFirstIndex + i) inSection:afterItem.indexPath.section]];
    }

    [_tableViewManager.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [_tableViewManager.tableView endUpdates];
}

- (void)deleteItems:(NSMutableArray<JRTableViewItem *> *)items
{
    [self deleteItems:items animation:UITableViewRowAnimationAutomatic];
}

- (void)deleteItems:(NSMutableArray<JRTableViewItem *> *)items animation:(UITableViewRowAnimation)animation
{
    
    [_tableViewManager.tableView beginUpdates];
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray new];

    for (JRTableViewItem *item in items) {
        [indexPaths addObject:item.indexPath];
    }
    
    [self.items removeObjectsInArray:items];

    [_tableViewManager.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [_tableViewManager.tableView endUpdates];
}

- (CGFloat)getAllCellHeight
{
    CGFloat height = 0;
    for (JRTableViewItem *item in self.items) {
        height += item.cellHeight;
    }
    
    if (self.headerItem != nil) {
        height += self.headerItem.height;
    }
    
    if (self.footerItem != nil) {
        height += self.footerItem.height;
    }
    
    return height;
}

- (void)reload
{
    [self reload:UITableViewRowAnimationAutomatic];
}

- (void)reload:(UITableViewRowAnimation)animation
{
    if ([_tableViewManager.sections containsObject:self]) {
        [_tableViewManager.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.index] withRowAnimation:animation];
    }
}

- (NSUInteger)index
{
    return [_tableViewManager.sections indexOfObject:self];
}

@end
