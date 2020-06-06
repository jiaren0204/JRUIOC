//
//  JRCollectionViewCell.h
//  JRCollectionView
//
//  Created by  梁嘉仁 on 16/8/29.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRCollectionViewItem.h"

@interface JRCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JRCollectionViewItem *item;

- (void)setupConfig;
- (void)update:(JRCollectionViewItem *)item;
- (void)didSelect;
- (void)didDeselect;
- (void)didHighlight;
- (void)didUnhighlight;


- (void)performCellEventWithName:(NSString *)name;
- (void)performCellEventWithName:(NSString *)name msg:(id)msg;

@end
