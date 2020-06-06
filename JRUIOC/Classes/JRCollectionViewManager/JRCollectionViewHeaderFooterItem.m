//
//  JRCollectionViewHeaderFooterItem.m
//  JRCollectionView
//
//  Created by 梁嘉仁 on 2020/4/7.
//  Copyright © 2020 梁嘉仁. All rights reserved.
//

#import "JRCollectionViewHeaderFooterItem.h"
#import "JRCollectionViewManager.h"
#import "JRCollectionViewSection.h"

@implementation JRCollectionViewHeaderFooterItem

- (instancetype)initWithHeaderFooterClass:(Class)headerFooterClass height:(CGFloat)height
{
    self = [super init];
    if (self) {
        self.height = height;
        
        self->_cellIdentifier = NSStringFromClass(headerFooterClass);
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
