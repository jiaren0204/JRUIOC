#import "JRTableViewManager.h"

@interface JRTableViewManager()<UITableViewDelegate, UITableViewDataSource>
///** cell事件调用 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, JRTableViewManagerCellEventBlock> *cellEventDic;

@property (nonatomic, strong) NSMutableDictionary<NSString *, JRTableViewManagerHeaderFooterEventBlock> *headerFooterEventDic;

@end

@implementation JRTableViewManager

+ (instancetype)createWithTableView:(UITableView *)tableView cellClasses:(NSArray<Class> *)cellClasses
{
    return [self createWithTableView:tableView cellClasses:cellClasses headerFooterClasses:@[]];
}

+ (instancetype)createWithTableView:(UITableView *)tableView cellClasses:(NSArray<Class> *)cellClasses headerFooterClasses:(NSArray<Class> *)headerFooterClasses
{
    JRTableViewManager *manager = [JRTableViewManager new];
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    tableView.layoutMargins = UIEdgeInsetsZero;
    tableView.delegate = manager;
    tableView.dataSource = manager;
    
    manager.tableView = tableView;
    
    manager.cellEventDic = [NSMutableDictionary new];
    manager.sections = [NSMutableArray new];
    manager.headerFooterEventDic = [NSMutableDictionary new];
    
    [cellClasses enumerateObjectsUsingBlock:^(Class  _Nonnull cls, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager registerWithCellClass:cls];
    }];
    
    [headerFooterClasses enumerateObjectsUsingBlock:^(Class  _Nonnull cls, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager registerHeadFootWithHeaderFooterClass:cls];
    }];

    return manager;
}


#pragma mark - tableView注册
/** 注册cellID */
- (void)registerWithCellClass:(Class)cellClass
{
    NSString *cellName = NSStringFromClass(cellClass);
    if ([self isCreateByNibWithCellName:cellName]) {
        [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
    }
    else {
        [self.tableView registerClass:cellClass forCellReuseIdentifier:cellName];
    }
}

/** 注册HeadFootID */
- (void)registerHeadFootWithHeaderFooterClass:(Class)headerFooterClass
{
    NSString *headerFooterName = NSStringFromClass(headerFooterClass);
    if ([self isCreateByNibWithCellName:headerFooterName]) {
        [self.tableView registerNib:[UINib nibWithNibName:headerFooterName bundle:nil] forHeaderFooterViewReuseIdentifier:headerFooterName];
    }
    else {
        [self.tableView registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:headerFooterName];
    }
}

/// use this method to update cell height after you change item.cellHeight.
- (void)updateHeight
{
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 11.0, *)) {
        [_tableView performBatchUpdates:^{
            
        } completion:^(BOOL finished) {
            [weakSelf.tableView reloadData];
        }];
    } else {
        [weakSelf.tableView reloadData];
    }
}

- (CGFloat)getAllCellHeight
{
    CGFloat height = 0;
    
    for (JRTableViewSection *section in self.sections) {
        height += [section getAllCellHeight];
    }

    return height;
}

#pragma mark - 辅助方法
/** 判断cell是否从XIB读取 */
- (BOOL)isCreateByNibWithCellName:(NSString *)cellName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.nib", cellName]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JRTableViewSection *section = self.sections[indexPath.section];
    JRTableViewItem *item = section.items[indexPath.row];
    if (item.isAutoDeselect) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }
    
    JRTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell didSelect];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JRTableViewSection *curSection = self.sections[section];
    return curSection.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JRTableViewSection *section = self.sections[indexPath.section];
    JRTableViewItem *item = section.items[indexPath.row];
    
    return item.cellHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    JRTableViewSection *section = self.sections[indexPath.section];
    JRTableViewItem *item = section.items[indexPath.row];
    
    JRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.cellIdentifier];
    if (cell == nil) {
        cell = [[JRTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:item.cellIdentifier];
    }
        
    cell.selectionStyle = item.selectionStyle;
    cell.item = item;
    [cell update:item];
    
    return cell;
}

#pragma mark tableView Header & Footer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JRTableViewSection *curSection = self.sections[section];
    JRTableViewHeaderFooterItem *item = curSection.headerItem;
    if (item == nil) {
        return nil;
    }
    
    JRTableViewHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:item.cellIdentifier];
    view.item = item;
    [view update:item];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    JRTableViewSection *curSection = self.sections[section];
    return curSection.headerItem == nil ? 0 : curSection.headerItem.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    JRTableViewSection *curSection = self.sections[section];
    JRTableViewHeaderFooterItem *item = curSection.footerItem;
    if (item == nil) {
        return nil;
    }
    
    JRTableViewHeaderFooterView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:item.cellIdentifier];
    view.item = item;
    [view update:item];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    JRTableViewSection *curSection = self.sections[section];
    return curSection.footerItem == nil ? 0 : curSection.footerItem.height;
}


- (void)add:(JRTableViewSection *)section
{
    section.tableViewManager = self;
    [self.sections addObject:section];
}

- (void)remove:(JRTableViewSection *)section
{
    [self.sections removeObject:section];
}

- (void)removeAll
{
    [self.sections removeAllObjects];
}

- (void)reload
{
    [self.tableView reloadData];
}

#pragma mark Cell事件处理
- (void)registerCellEventWithName:(NSString *)name block:(JRTableViewManagerCellEventBlock)block
{
    self.cellEventDic[name] = block;
}

- (void)performCellEventWithName:(NSString *)name item:(JRTableViewItem *)item msg:(id)msg
{
    JRTableViewManagerCellEventBlock callback = self.cellEventDic[name];
    if (callback) {
        callback(item, msg);
    }
}

- (void)registerHeaderFooterEventWithName:(NSString *)name block:(JRTableViewManagerHeaderFooterEventBlock)block
{
    self.headerFooterEventDic[name] = block;
}

- (void)performHeaderFooterEventWithName:(NSString *)name item:(JRTableViewHeaderFooterItem *)item msg:(id)msg
{
    JRTableViewManagerHeaderFooterEventBlock callback = self.headerFooterEventDic[name];
    if (callback) {
        callback(item, msg);
    }
}

@end
