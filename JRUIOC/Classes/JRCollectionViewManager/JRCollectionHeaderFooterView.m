//
//  JRCollectionReusableView.m
//  JRCollectionView
//
//  Created by 嘉仁 on 16/9/1.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import "JRCollectionHeaderFooterView.h"
#import "JRCollectionViewManager.h"

@implementation JRCollectionHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupConfig];
}

- (void)setupConfig
{
    
}

- (void)update:(JRCollectionViewHeaderFooterItem *)item{}

- (void)performHeaderFooterEventWithName:(NSString *)name
{
    [self performHeaderFooterEventWithName:name msg:nil];
}

- (void)performHeaderFooterEventWithName:(NSString *)name msg:(id)msg
{
    [_item.manager performHeaderFooterEventWithName:name item:_item msg:msg];
}


@end
