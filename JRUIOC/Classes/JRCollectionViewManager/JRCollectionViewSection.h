#import <Foundation/Foundation.h>

@class JRCollectionViewManager, JRCollectionViewItem, JRCollectionViewHeaderFooterItem;

NS_ASSUME_NONNULL_BEGIN

@interface JRCollectionViewSection : NSObject

@property (nonatomic, weak) JRCollectionViewManager *manager;

@property (nonatomic, strong) JRCollectionViewHeaderFooterItem *headerItem;
@property (nonatomic, strong) JRCollectionViewHeaderFooterItem *footererItem;
@property (nonatomic, strong) NSMutableArray<JRCollectionViewItem *> *items;

@property (nonatomic, assign, readonly) NSUInteger index;


- (void)add:(JRCollectionViewItem *)item;

- (void)remove:(JRCollectionViewItem *)item;
- (void)removeAllItems;

- (void)insertItem:(JRCollectionViewItem *)item afterItem:(JRCollectionViewItem *)afterItem;
- (void)insertItems:(NSArray<JRCollectionViewItem *> *)items afterItem:(JRCollectionViewItem *)afterItem;

- (void)deleteItems:(NSArray<JRCollectionViewItem *> *)items;

- (void)reload;
- (void)reloadItems:(NSArray<JRCollectionViewItem *> *)items;


@end

NS_ASSUME_NONNULL_END
