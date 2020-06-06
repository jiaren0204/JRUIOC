#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JRPopupViewBaseAnimator.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JRPopUpAppearType) {
    JRPopUpAppearTypeTop = 0,
    JRPopUpAppearTypeCenter,
    JRPopUpAppearTypeBottom,
    JRPopUpAppearTypeCustomCenter,
    JRPopUpAppearTypeCustomPoint
};


/** Display Attributes */
@interface JRPopAttributes : NSObject

@property (nonatomic, strong) UIView *containerView;
/** 初始化位置 */
@property (nonatomic, assign) JRPopUpAppearType appearType;
/** 点击遮罩关闭 */
@property (nonatomic, assign) BOOL isDismissible;
/** 点击遮罩颜色 */
@property (nonatomic, strong) UIColor *bgColor;
/** 动画驱动器 */
@property (nonatomic, strong) JRPopupViewBaseAnimator *animator;


@end

NS_ASSUME_NONNULL_END
