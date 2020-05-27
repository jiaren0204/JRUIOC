//
//  JRTableViewCell.h
//  JRTableView
//
//  Created by  梁嘉仁 on 16/7/14.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRTableViewItem.h"

@interface JRTableViewCell : UITableViewCell
@property (nonatomic, strong) JRTableViewItem *item;

- (void)setupConfig;
- (void)update:(JRTableViewItem *)item;
- (void)didSelect;

- (void)performCellEventWithName:(NSString *)name;
- (void)performCellEventWithName:(NSString *)name msg:(id)msg;

@end
