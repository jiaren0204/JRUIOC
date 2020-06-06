//
//  JRTableViewCell.m
//  JRTableView
//
//  Created by  梁嘉仁 on 16/7/14.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import "JRTableViewCell.h"
#import "JRTableViewManager.h"

@implementation JRTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self defaultSet];
        [self setupConfig];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSet];
        [self setupConfig];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self defaultSet];
    [self setupConfig];
}

- (void)defaultSet
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupConfig{}
- (void)update:(JRTableViewItem *)item{}
- (void)didSelect{}

- (void)performCellEventWithName:(NSString *)name
{
    [self performCellEventWithName:name msg:nil];
}

- (void)performCellEventWithName:(NSString *)name msg:(id)msg
{
    [self.item.tableViewManager performCellEventWithName:name item:self.item msg:msg];
}


@end
