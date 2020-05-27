#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JRTableViewManager, JRTableViewSection;

@interface JRTableViewHeaderFooterItem : NSObject
@property (nonatomic, weak) JRTableViewManager *tableViewManager;
@property (nonatomic, weak) JRTableViewSection *section;

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, assign) CGFloat height;

- (instancetype)initWithHeaderFooterClass:(Class)headerFooterClass height:(CGFloat)height;
+ (instancetype)itemWithHeaderFooterClass:(Class)headerFooterClass height:(CGFloat)height;

- (void)setupConfig;

@end

NS_ASSUME_NONNULL_END



