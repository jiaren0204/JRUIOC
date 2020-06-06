//
//  JRTableViewHeaderFooterView.m
//  JRTableView
//
//  Created by 嘉仁 on 2016/11/2.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import "JRTableViewHeaderFooterView.h"
#import "JRTableViewManager.h"

@implementation JRTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
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

- (void)setupConfig{}
- (void)update:(JRTableViewHeaderFooterItem *)item{}

- (void)performHeaderFooterEventWithName:(NSString *)name
{
    [self performHeaderFooterEventWithName:name msg:nil];
}

- (void)performHeaderFooterEventWithName:(NSString *)name msg:(id)msg
{
    [self.item.tableViewManager performHeaderFooterEventWithName:name item:self.item msg:msg];
}


@end



