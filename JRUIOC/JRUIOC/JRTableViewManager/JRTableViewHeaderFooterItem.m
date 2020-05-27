#import "JRTableViewHeaderFooterItem.h"

@implementation JRTableViewHeaderFooterItem

- (instancetype)initWithHeaderFooterClass:(Class)headerFooterClass height:(CGFloat)height
{
    self = [super init];
    if (self) {
        self.height = height;
        
        self.cellIdentifier = NSStringFromClass(headerFooterClass);
        [self setupConfig];
    }
    return self;
}

+ (instancetype)itemWithHeaderFooterClass:(Class)headerFooterClass height:(CGFloat)height
{
    return [[self alloc] initWithHeaderFooterClass:headerFooterClass height:height];
}

- (void)setupConfig{}

@end
