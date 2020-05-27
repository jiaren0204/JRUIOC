#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JRTableViewSection.h"
#import "JRTableViewItem.h"
#import "JRTableViewHeaderFooterItem.h"
#import "JRTableViewCell.h"
#import "JRTableViewHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JRTableViewManagerCellEventBlock)(JRTableViewItem *item, id msg);
typedef void(^JRTableViewManagerHeaderFooterEventBlock)(JRTableViewHeaderFooterItem *item, id msg);

@interface JRTableViewManager : NSObject
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<JRTableViewSection *> *sections;

+ (instancetype)createWithTableView:(UITableView *)tableView cellClasses:(NSArray<Class> *)cellClasses;
+ (instancetype)createWithTableView:(UITableView *)tableView cellClasses:(NSArray<Class> *)cellClasses headerFooterClasses:(NSArray<Class> *)headerFooterClasses;

- (void)updateHeight;
- (CGFloat)getAllCellHeight;

- (void)add:(JRTableViewSection *)section;
- (void)remove:(JRTableViewSection *)section;
- (void)removeAll;
- (void)reload;

#pragma mark Cell事件处理
- (void)registerCellEventWithName:(NSString *)name block:(JRTableViewManagerCellEventBlock)block;
- (void)performCellEventWithName:(NSString *)name item:(JRTableViewItem *)item msg:(id)msg;

- (void)registerHeaderFooterEventWithName:(NSString *)name block:(JRTableViewManagerHeaderFooterEventBlock)block;
- (void)performHeaderFooterEventWithName:(NSString *)name item:(JRTableViewHeaderFooterItem *)item msg:(id)msg;
@end

NS_ASSUME_NONNULL_END
