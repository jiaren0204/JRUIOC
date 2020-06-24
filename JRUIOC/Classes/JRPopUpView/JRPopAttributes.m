#import "JRPopAttributes.h"

@implementation JRPopAttributes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.containerView = [UIApplication sharedApplication].windows.firstObject;
        self.appearType = JRPopUpAppearTypeCenter;
        self.isDismissible = YES;
        self.bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.animator = [JRPopupViewAlphaAnimator new];
        self.dismissExistViews = YES;
    }
    return self;
}

@end
