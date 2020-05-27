#import "JRTableViewItem.h"
#import "JRTableViewManager.h"

@implementation JRTableViewItem

- (instancetype)initWithCellClass:(Class)cellClass cellHeight:(CGFloat)cellHeight
{
    self = [super init];
    if (self) {
        self.cellHeight = cellHeight;
        
        self.cellIdentifier = NSStringFromClass(cellClass);
        self.isAutoDeselect = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)itemWithCellClass:(Class)cellClass cellHeight:(CGFloat)cellHeight
{
    return [[self alloc] initWithCellClass:cellClass cellHeight:cellHeight];
}

- (NSIndexPath *)indexPath
{
    NSUInteger row = [_section.items indexOfObject:self];
    NSUInteger section = [_tableViewManager.sections indexOfObject:_section];
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)reload
{
    [self reload:UITableViewRowAnimationAutomatic];
}

- (void)reload:(UITableViewRowAnimation)animation
{
    [_tableViewManager.tableView beginUpdates];
    [_tableViewManager.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
    [_tableViewManager.tableView endUpdates];
}

- (void)remove
{
    [self remove:UITableViewRowAnimationAutomatic];
}

- (void)remove:(UITableViewRowAnimation)animation
{
    if (_tableViewManager == nil || _section == nil) {
        NSLog(@"Item did not in section or manager，please check section add method");
        return;
    }
    
    if ([_section.items containsObject:self] == NO) {
        NSLog(@"can't delete because this item did not in section");
        return;
    }
    
    NSIndexPath *indexPath = self.indexPath;
    [_section.items removeObject:self];
    [_tableViewManager.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)setupConfig{}
- (void)calculate{}


@end
