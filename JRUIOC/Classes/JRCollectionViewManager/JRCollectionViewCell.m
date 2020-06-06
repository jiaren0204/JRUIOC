//
//  JRCollectionViewCell.m
//  JRCollectionView
//
//  Created by  梁嘉仁 on 16/8/29.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import "JRCollectionViewCell.h"
#import "JRCollectionViewManager.h"

@implementation JRCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupConfig];
    }
    return self;
}

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
    self.contentView.backgroundColor = [UIColor clearColor];
}


- (void)update:(JRCollectionViewItem *)item{}
- (void)didSelect{}
- (void)didDeselect{}
- (void)didHighlight{}
- (void)didUnhighlight{}

- (void)performCellEventWithName:(NSString *)name
{
    [self performCellEventWithName:name msg:nil];
}

- (void)performCellEventWithName:(NSString *)name msg:(id)msg
{
    [_item.manager performCellEventWithName:name item:_item msg:msg];
}



@end
