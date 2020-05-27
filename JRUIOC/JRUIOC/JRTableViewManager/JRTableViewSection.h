#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JRTableViewManager, JRTableViewItem, JRTableViewHeaderFooterItem;

NS_ASSUME_NONNULL_BEGIN

@interface JRTableViewSection : NSObject

@property (nonatomic, weak) JRTableViewManager *tableViewManager;

@property (nonatomic, strong) JRTableViewHeaderFooterItem *headerItem;
@property (nonatomic, strong) JRTableViewHeaderFooterItem *footerItem;
@property (nonatomic, strong) NSMutableArray<JRTableViewItem *> *items;

@property (nonatomic, assign, readonly) NSUInteger index;


- (void)add:(JRTableViewItem *)item;
- (void)remove:(JRTableViewItem *)item;
- (void)removeAllItems;

- (void)moveItem:(JRTableViewItem *)item toRow:(NSInteger)toRow;

- (void)insertItem:(JRTableViewItem *)item afterItem:(JRTableViewItem *)afterItem;
- (void)insertItem:(JRTableViewItem *)item afterItem:(JRTableViewItem *)afterItem animation:(UITableViewRowAnimation)animation;

- (void)insertItems:(NSArray<JRTableViewItem *> *)items afterItem:(JRTableViewItem *)afterItem;
- (void)insertItems:(NSArray<JRTableViewItem *> *)items afterItem:(JRTableViewItem *)afterItem animation:(UITableViewRowAnimation)animation;

- (void)deleteItems:(NSMutableArray<JRTableViewItem *> *)items;
- (void)deleteItems:(NSMutableArray<JRTableViewItem *> *)items animation:(UITableViewRowAnimation)animation;

- (CGFloat)getAllCellHeight;
- (void)reload;
- (void)reload:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END
