#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JRTableViewManager, JRTableViewSection;

#define JR_TABLE_ITEM_CONVERT(itemName) itemName *item = (itemName *)self.item;
#define JR_TABLE_ITEM_CONVERT_SELF(itemName, self) itemName *item = (itemName *)self.item;

NS_ASSUME_NONNULL_BEGIN

@interface JRTableViewItem : NSObject
@property (nonatomic, weak) JRTableViewManager *tableViewManager;
@property (nonatomic, weak) JRTableViewSection *section;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, assign) BOOL isAutoDeselect;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;

+ (instancetype)itemWithCellClass:(Class)cellClass cellHeight:(CGFloat)cellHeight;
- (instancetype)initWithCellClass:(Class)cellClass cellHeight:(CGFloat)cellHeight;
- (void)setupConfig;
- (void)calculate;

- (void)reload;

- (void)reload:(UITableViewRowAnimation)animation;

- (void)remove;
- (void)remove:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END
