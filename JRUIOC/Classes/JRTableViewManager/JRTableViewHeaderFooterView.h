//
//  JRTableViewHeaderFooterView.h
//  JRTableView
//
//  Created by 嘉仁 on 2016/11/2.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRTableViewHeaderFooterItem.h"

@interface JRTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) JRTableViewHeaderFooterItem *item;

- (void)setupConfig;
- (void)update:(JRTableViewHeaderFooterItem *)item;

- (void)performHeaderFooterEventWithName:(NSString *)name;
- (void)performHeaderFooterEventWithName:(NSString *)name msg:(id)msg;

@end
