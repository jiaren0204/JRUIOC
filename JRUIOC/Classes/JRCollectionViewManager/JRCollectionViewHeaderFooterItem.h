//
//  JRCollectionViewHeaderFooterItem.h
//  JRCollectionView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JRCollectionViewManager, JRCollectionViewSection;

NS_ASSUME_NONNULL_BEGIN

@interface JRCollectionViewHeaderFooterItem : NSObject

@property (nonatomic, weak) JRCollectionViewManager *manager;
@property (nonatomic, weak) JRCollectionViewSection *section;

@property (nonatomic, copy, readonly) NSString *cellIdentifier;
@property (nonatomic, assign) CGFloat height;

+ (instancetype)itemWithHeaderFooterClass:(Class)headerFooterClass height:(CGFloat)height;
- (instancetype)initWithHeaderFooterClass:(Class)headerFooterClass height:(CGFloat)height;

- (void)setupConfig;

@end

NS_ASSUME_NONNULL_END
