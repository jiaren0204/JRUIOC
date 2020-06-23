//
//  JRCollectionViewLayout.m
//  JRCollectionView
//
//  Created by 嘉仁 on 16/8/30.
//  Copyright © 2016年  梁嘉仁. All rights reserved.
//

#import "JRCustomSizeLayout.h"
#import "JRCollectionViewManager.h"



@interface JRItemFrame : NSObject
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

+ (instancetype)size:(CGSize)size;
+ (instancetype)frame:(CGRect)frame;

- (CGRect)frame;
- (CGPoint)center;
- (CGFloat)centerX;
- (CGFloat)centerY;
@end

@implementation JRItemFrame

+ (instancetype)size:(CGSize)size
{
    return [self frame:(CGRect){CGPointZero, size}];
}

+ (instancetype)frame:(CGRect)frame
{
    JRItemFrame *itemSize = [JRItemFrame new];
    itemSize.x = frame.origin.x;
    itemSize.y = frame.origin.y;
    itemSize.width = frame.size.width;
    itemSize.height = frame.size.height;
    return itemSize;
}

- (CGRect)frame
{
    return CGRectMake(_x, _y, _width, _height);
}

- (CGPoint)center
{
    return (CGPoint){[self centerX], [self centerY]};
}

- (CGFloat)centerX
{
    return _x + _width * 0.5;
}

- (CGFloat)centerY
{
    return _y + _height * 0.5;
}

- (NSString *)description
{
    NSDictionary *dic = @{
                          @"x" : @(_x),
                          @"y" : @(_y),
                          @"width" : @(_width),
                          @"height" : @(_height)
                          };
    
    return [dic description];
}

@end

@interface JRSectionInfo : NSObject

@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) CGFloat sectionMaxY;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, strong) JRItemFrame *headerFrame;
@property (nonatomic, strong) JRItemFrame *footerFrame;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *numberOfItemsDic;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray<JRItemFrame *> *> *itemSizesDic;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, JRItemFrame *> *itemFrameDic;

@end

@implementation JRSectionInfo

- (NSString *)description
{
    id(^logObjectBlock)(id obj) = ^id(id obj){
        if (obj == nil) {
            return @"";
        }
        
        return obj;
    };

    NSDictionary *dic = @{
                          @"numberOfRows" : @(_numberOfRows),
                          @"sectionMaxY" : @(_sectionMaxY),
                          @"headerFrame" : logObjectBlock(_headerFrame),
                          @"footerFrame" : logObjectBlock(_footerFrame)
                          };
    return [dic description];
}



@end

typedef NS_ENUM(NSInteger, JRSectionInfoValue) {
    JRSectionInfoValueRows = 0,
    JRSectionInfoValueSectionMaxY,
    JRSectionInfoValueHeaderFrame,
    JRSectionInfoValueFooterFrame,
    JRSectionInfoValueNumberOfItems,
    JRSectionInfoValueitemSizes,
    JRSectionInfoValueitemFrame
};



@interface JRCustomSizeLayoutTool : NSObject

@property (nonatomic, assign) CGFloat collectionViewTotalWidth;

- (BOOL)hasSectionInfo:(NSInteger)section;

/******* 设置功能 *******/
- (void)setSection:(NSInteger)section numberOfRows:(NSInteger)rows;

- (void)setSection:(NSInteger)section sectionMaxY:(CGFloat)MaxY;

- (void)setSection:(NSInteger)section headerFrame:(JRItemFrame *)headerFrame;

- (void)setSection:(NSInteger)section footerFrame:(JRItemFrame *)footerFrame;

- (void)setSection:(NSInteger)section row:(NSInteger)row numberOfItems:(NSInteger)items;

- (void)setSection:(NSInteger)section row:(NSInteger)row itemSizes:(NSArray<JRItemFrame *> *)itemSizes;

- (void)setSection:(NSInteger)section item:(NSInteger)item itemFrame:(JRItemFrame *)itemFrame;


/******* 查询功能 *******/
/** 查询section的总行数 */
- (NSInteger)queryNumberOfRowsAtSection:(NSInteger)section;

/** 查询section的最大Y值 */
- (CGFloat)querySectionMaxYAtSection:(NSInteger)section;

/** 查询section的header的Frame */
- (JRItemFrame *)querySectionHeaderFrameAtSection:(NSInteger)section;

/** 查询section的footer的Frame */
- (JRItemFrame *)querySectionFooterFrameAtSection:(NSInteger)section;

/** 查询一行的item个数 */
- (NSInteger)queryNumberOfItemsAtSection:(NSInteger)section row:(NSInteger)row;

/** 查询一行的item的Size */
- (NSArray<JRItemFrame *> *)queryItemSizesAtSection:(NSInteger)section row:(NSInteger)row;

/** 查询一行的item的Size */
- (JRItemFrame *)queryItemFrameAtSection:(NSInteger)section item:(NSInteger)item;

- (CGFloat)getCollectionViewTotalHeight;


/******* 清除功能 *******/
- (void)clean;



@end



@interface JRCustomSizeLayoutTool ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, JRSectionInfo *> *sectionInfoDic;

@end

@implementation JRCustomSizeLayoutTool

- (NSMutableDictionary<NSNumber *,JRSectionInfo *> *)sectionInfoDic
{
    if (_sectionInfoDic == nil) {
        _sectionInfoDic = [NSMutableDictionary new];
    }
    return _sectionInfoDic;
}

- (BOOL)hasSectionInfo:(NSInteger)section
{
    return self.sectionInfoDic[@(section)].numberOfItemsDic != nil;
}

- (void)setType:(JRSectionInfoValue)type Section:(NSInteger)section key:(NSNumber *)key value:(id)value
{
    JRSectionInfo *info = self.sectionInfoDic[@(section)];
    if (info == nil) {
        info = [JRSectionInfo new];
    }

    switch (type) {
        case JRSectionInfoValueRows:            info.numberOfRows = ((NSNumber *)value).integerValue;  break;
        case JRSectionInfoValueSectionMaxY:     info.sectionMaxY = ((NSNumber *)value).floatValue;  break;
        case JRSectionInfoValueHeaderFrame:    info.headerFrame = (JRItemFrame *)value;  break;
        case JRSectionInfoValueFooterFrame:    info.footerFrame = (JRItemFrame *)value;  break;
        case JRSectionInfoValueNumberOfItems: {
            NSMutableDictionary<NSNumber *, NSNumber *> *numberOfItemsDic = info.numberOfItemsDic;
            if (numberOfItemsDic == nil) {
                numberOfItemsDic = [NSMutableDictionary new];
            }
            numberOfItemsDic[key] = (NSNumber *)value;
            info.numberOfItemsDic = numberOfItemsDic;
            break;
        }
        case JRSectionInfoValueitemSizes: {
            NSMutableDictionary<NSNumber *, NSArray<JRItemFrame *> *> *itemSizesDic = info.itemSizesDic;
            if (itemSizesDic == nil) {
                itemSizesDic = [NSMutableDictionary new];
            }
            itemSizesDic[key] = (NSArray<JRItemFrame *> *)value;
            info.itemSizesDic = itemSizesDic;
            break;
        }
        case JRSectionInfoValueitemFrame: {
            NSMutableDictionary<NSNumber *, JRItemFrame *> *itemFrameDic = info.itemFrameDic;
            if (itemFrameDic == nil) {
                itemFrameDic = [NSMutableDictionary new];
            }
            itemFrameDic[key] = (JRItemFrame *)value;
            info.itemFrameDic = itemFrameDic;
            break;
        }
        default: break;
    }


    self.sectionInfoDic[@(section)] = info;
}

- (void)setSection:(NSInteger)section numberOfRows:(NSInteger)rows
{
    [self setType:JRSectionInfoValueRows Section:section key:nil value:@(rows)];
}


- (void)setSection:(NSInteger)section sectionMaxY:(CGFloat)MaxY
{
    [self setType:JRSectionInfoValueSectionMaxY Section:section key:nil value:@(MaxY)];
}

- (void)setSection:(NSInteger)section headerFrame:(JRItemFrame *)headerFrame
{
    [self setType:JRSectionInfoValueHeaderFrame Section:section key:nil value:headerFrame];
}


- (void)setSection:(NSInteger)section footerFrame:(JRItemFrame *)footerFrame
{
    [self setType:JRSectionInfoValueFooterFrame Section:section key:nil value:footerFrame];
}

- (void)setSection:(NSInteger)section row:(NSInteger)row numberOfItems:(NSInteger)items
{
    [self setType:JRSectionInfoValueNumberOfItems Section:section key:@(row) value:@(items)];
}

- (void)setSection:(NSInteger)section row:(NSInteger)row itemSizes:(NSArray<JRItemFrame *> *)itemSizes
{
    [self setType:JRSectionInfoValueitemSizes Section:section key:@(row) value:itemSizes];
}

- (void)setSection:(NSInteger)section item:(NSInteger)item itemFrame:(JRItemFrame *)itemFrame
{
    [self setType:JRSectionInfoValueitemFrame Section:section key:@(item) value:itemFrame];
}

///******* 查询功能 *******/
///** 查询section的总行数 */
- (NSInteger)queryNumberOfRowsAtSection:(NSInteger)section
{
    return self.sectionInfoDic[@(section)].numberOfRows;
}

///** 查询section的最大Y值 */
- (CGFloat)querySectionMaxYAtSection:(NSInteger)section
{
    return self.sectionInfoDic[@(section)].sectionMaxY;
}

///** 查询section的header高度 */
- (JRItemFrame *)querySectionHeaderFrameAtSection:(NSInteger)section
{
    return self.sectionInfoDic[@(section)].headerFrame;
}

///** 查询section的footer高度 */
- (JRItemFrame *)querySectionFooterFrameAtSection:(NSInteger)section
{
    return self.sectionInfoDic[@(section)].footerFrame;
}

///** 查询一行的item个数 */
- (NSInteger)queryNumberOfItemsAtSection:(NSInteger)section row:(NSInteger)row
{
    return self.sectionInfoDic[@(section)].numberOfItemsDic[@(row)].integerValue;
}

///** 查询一行的item的Size */
- (NSArray<JRItemFrame *> *)queryItemSizesAtSection:(NSInteger)section row:(NSInteger)row
{
    return self.sectionInfoDic[@(section)].itemSizesDic[@(row)];
}

- (JRItemFrame *)queryItemFrameAtSection:(NSInteger)section item:(NSInteger)item;
{
    return self.sectionInfoDic[@(section)].itemFrameDic[@(item)];
}

- (CGFloat)getCollectionViewTotalHeight
{
    NSNumber *height = [[self.sectionInfoDic allValues] valueForKeyPath:@"@max.sectionMaxY"];
    return height.doubleValue;
}

- (void)clean
{
    [self.sectionInfoDic removeAllObjects];
}

@end

@interface JRCustomSizeLayout ()
@property (nonatomic, strong) JRCustomSizeLayoutTool *layoutTool;
@property (nonatomic, assign) CGFloat collectViewW;
@end

@implementation JRCustomSizeLayout


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layoutTool = [JRCustomSizeLayoutTool new];
    }
    return self;
}

- (void)setManager:(JRCollectionViewManager *)manager
{
    _manager = manager;
    
    __weak typeof(self) weakSelf = self;
    [manager addCollectionEventListenerWithId:self name:(JR_CollectionViewEventDataDidChanged) block:^{
        [weakSelf.layoutTool clean];
    }];
}

- (void)prepareLayout
{
    [super prepareLayout];
    _collectViewW = _manager.collectionView.bounds.size.width - _manager.collectionView.contentInset.left - _manager.collectionView.contentInset.right;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

//- (CGSize)getCellSizeWithCellName:(NSString *)cellName model:(id)model type:(JRViewType)type
//{
//    if (type == JRViewTypeCell) {
//        JRCollectionViewCell *cell = self.cellDic[cellName];
//        if (cell == nil) {
//            // 判断cell是否从XIB创建
//            cell = IsCreateByNibWithCellName(cellName) ?
//            [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil].lastObject :
//            [NSClassFromString(cellName) new];
//
//            cell.jr_collectionView = (JRCollectionView *)self.collectionView;
//            self.cellDic[cellName] = cell;
//        }
//
//        setCellModel(cell, model);
//
//        return [cell getCellSize];
//    }
//    else {
//        JRCollectionHeaderFooterView *headerFooter = self.headerFooterDic[cellName];
//        if (headerFooter == nil) {
//            // 判断cell是否从XIB创建
//            headerFooter = IsCreateByNibWithCellName(cellName) ?
//            [[NSBundle mainBundle] loadNibNamed:cellName owner:nil options:nil].lastObject :
//            [NSClassFromString(cellName) new];
//
//            headerFooter.jr_collectionView = (JRCollectionView *)self.collectionView;
//            self.headerFooterDic[cellName] = headerFooter;
//        }
//
//        setCellModel(headerFooter, model);
//
//        return [headerFooter getCellSize];
//    }
//}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    JRCollectionViewSection *section = _manager.sections[indexPath.section];
    
  
    if (section.headerItem != nil && [elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        JRItemFrame *headerFrame = [self.layoutTool querySectionHeaderFrameAtSection:indexPath.section];
        
        if (headerFrame == nil) {
            // 取出上一个section的
            CGFloat lastSectionMaxY = 0;
            if (indexPath.section > 0) {
                lastSectionMaxY = [self.layoutTool querySectionMaxYAtSection:(indexPath.section - 1)] + self.minimumLineSpacing;
            }
            
            attributes.frame = CGRectMake(0, lastSectionMaxY, _collectViewW, section.headerItem.height);
            
            [self.layoutTool setSection:indexPath.section headerFrame:[JRItemFrame frame:attributes.frame]];
            [self.layoutTool setSection:indexPath.section sectionMaxY:lastSectionMaxY + section.headerItem.height];
        }
        else {
            attributes.frame = headerFrame.frame;
        }
    }
    

    if (section.footererItem != nil && [elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        JRItemFrame *footerFrame = [self.layoutTool querySectionFooterFrameAtSection:indexPath.section];
        
        if (footerFrame == nil) {
            
            // 取出当前section的最大Y值
            CGFloat sectionMaxY = [self.layoutTool querySectionMaxYAtSection:indexPath.section];
            
            attributes.frame = CGRectMake(0, sectionMaxY, _collectViewW, section.footererItem.height);
            [self.layoutTool setSection:indexPath.section footerFrame:[JRItemFrame frame:attributes.frame]];
            
            // 每组的总高度(+footer)
            [self.layoutTool setSection:indexPath.section sectionMaxY:sectionMaxY + section.footererItem.height];
        }
        else {
            attributes.frame = footerFrame.frame;
        }
    }

    return attributes;
}

/** 设置每一个item的属性 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    JRCollectionViewSection *section = _manager.sections[indexPath.section];
    JRCollectionViewItem *item = section.items[indexPath.item];

    /** 设置size */
    attributes.size = item.cellSize;

    /** 计算每一组,一行个数,多少行,一行item的Size */
    if ([self.layoutTool hasSectionInfo:indexPath.section] == NO) { // 当前组没有任何计算数据
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            [self verticalLayoutInfo:section indexPath:indexPath];
        }
        else {
            [self horizontalLayoutInfo:section indexPath:indexPath];
        }
    }


    /** 计算indexPath属于第几行,第几列 */
    uint16_t col = 0;
    uint16_t row = 0;
    [self calculateCurrentItemRow:&row col:&col withIndexPath:indexPath];

    /** 计算item位置 */
    JRItemFrame *currentFrame = [self.layoutTool queryItemFrameAtSection:indexPath.section item:indexPath.item];
    
    if (currentFrame == nil) {
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            
            JRItemFrame *headerFrame = [self.layoutTool querySectionHeaderFrameAtSection:indexPath.section];
            
            /** 把上一section的高度取出来 */
            CGFloat previousSectionMaxY = 0;
            if (indexPath.section > 0) {
                previousSectionMaxY = [self.layoutTool querySectionMaxYAtSection:(indexPath.section - 1)] + (headerFrame.height ? self.minimumLineSpacing : 0);
            }
            
            NSArray<JRItemFrame *> *rowSizeArr = [self.layoutTool queryItemSizesAtSection:indexPath.section row:row];
            
            // 当前item上面每一行最大高高度+minimumLineSpacing
            CGFloat originY = 0;
            for (int i = 0; i < row; i++) {
                originY += [[[self.layoutTool queryItemSizesAtSection:indexPath.section row:i] valueForKeyPath:@"@max.height"] doubleValue] + self.minimumLineSpacing;
            }
            
            CGFloat itemY = previousSectionMaxY + originY + (headerFrame.height ?: self.minimumLineSpacing);
            
            // 当前item前面所有item+minimumInteritemSpacing的宽度
            CGFloat originX = 0;
            for (int i = 0; i < col; i++) {
                originX += rowSizeArr[i].width + self.minimumInteritemSpacing;
            }
            
            CGFloat itemX = self.sectionInset.left + originX;
            
            // 每组的总高度(最后一行:ItemY+最高的item+footer)
            if (indexPath.item == section.items.count - 1) {
                NSNumber *maxHeight = [[self.layoutTool queryItemSizesAtSection:indexPath.section row:row] valueForKeyPath:@"@max.height"];
                [self.layoutTool setSection:indexPath.section sectionMaxY:(itemY + maxHeight.floatValue + self.sectionInset.top + self.sectionInset.bottom)];
            }
            
            attributes.frame = (CGRect){{itemX, itemY}, attributes.size};
            [self.layoutTool setSection:indexPath.section item:indexPath.item itemFrame:[JRItemFrame frame:attributes.frame]];

        }
        else {
            NSArray<JRItemFrame *> *rowSizeArr = [self.layoutTool queryItemSizesAtSection:indexPath.section row:row];
            
            CGFloat itemY = self.minimumLineSpacing;
            
            // 当前item前面所有item+minimumInteritemSpacing的宽度
            CGFloat originX = 0;
            for (int i = 0; i < indexPath.item; i++) {
                originX += rowSizeArr[i].width + self.minimumInteritemSpacing;
            }
            
            CGFloat itemX = self.sectionInset.left + originX ;
            
            attributes.frame = (CGRect){{itemX, itemY}, attributes.size};
            [self.layoutTool setSection:indexPath.section item:indexPath.item itemFrame:[JRItemFrame frame:attributes.frame]];
            
            if (indexPath.item == section.items.count - 1) {
                _layoutTool.collectionViewTotalWidth = itemX + rowSizeArr[indexPath.item].width;
            }
        }
    }
    else {
        attributes.frame = currentFrame.frame;
    }

    return attributes;
}

/** 垂直方向滚动布局 */
- (void)verticalLayoutInfo:(JRCollectionViewSection *)section indexPath:(NSIndexPath *)indexPath
{
    NSInteger rowItem = 0;
    NSInteger row = 0;
    CGFloat maxRowWidth = 0;
    NSMutableArray<JRItemFrame *> *itemSizeArr = [NSMutableArray new];
    
    for (int i = 0; i < section.items.count; i++) {
        JRCollectionViewItem *item = section.items[i];
        
        /** size */
        JRItemFrame *itemSize = [JRItemFrame size:item.cellSize];
        
        maxRowWidth += (item.cellSize.width + self.minimumInteritemSpacing);
        
        if (maxRowWidth <= _collectViewW ||
            (maxRowWidth - self.minimumInteritemSpacing) <= _collectViewW
            ) {  //  超出collectView宽度换行
            [itemSizeArr addObject:itemSize];
            ++rowItem;
        } else {
            maxRowWidth = (item.cellSize.width + self.minimumInteritemSpacing);
            [self.layoutTool setSection:indexPath.section
                                    row:row
                              itemSizes:[itemSizeArr mutableCopy]];  // 设置:一行所有item的Size
            
            [itemSizeArr removeAllObjects];
            [itemSizeArr addObject:itemSize];
            rowItem = 1;
            ++row;
        }
        
        [self.layoutTool setSection:indexPath.section row:row numberOfItems:rowItem]; // 设置:一行有多少个item
        [self.layoutTool setSection:indexPath.section numberOfRows:(row + 1)];  // 设置:一组有多少行
    }
    
    if (itemSizeArr.count) {
        [self.layoutTool setSection:indexPath.section
                                row:row
                          itemSizes:[itemSizeArr mutableCopy]];  // 设置:一行所有item的Size
    }
}

/** 水平方向滚动布局 */
- (void)horizontalLayoutInfo:(JRCollectionViewSection *)section indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray<JRItemFrame *> *itemSizeArr = [NSMutableArray new];
    
    NSUInteger itemsCount = section.items.count;
    for (int i = 0; i < itemsCount; i++) {
        JRCollectionViewItem *item = section.items[i];
        
        /** size */
        JRItemFrame *itemSize = [JRItemFrame size:item.cellSize];
        
        [itemSizeArr addObject:itemSize];
        
        if (i == itemsCount - 1) {
            [self.layoutTool setSection:indexPath.section
                                    row:0
                              itemSizes:itemSizeArr];  // 设置:一行所有item的Size
        }
    }
}

/** 计算当前item的row和col */
- (void)calculateCurrentItemRow:(uint16_t *)row col:(uint16_t *)col withIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalItem = 0;
    NSInteger rowCount = [self.layoutTool queryNumberOfRowsAtSection:indexPath.section];
    for (int i = 0; i < rowCount; i++) {
        totalItem += [self.layoutTool queryNumberOfItemsAtSection:indexPath.section row:i];
        
        if ((int)(indexPath.item * 1.0 / totalItem) == 0) {
            *row = i;
            
            if (*row > 0) {
                *col = indexPath.item - (totalItem - [self.layoutTool queryNumberOfItemsAtSection:indexPath.section row:i]);
            }
            else {
                *col = indexPath.item;
            }
            
            break;
        }
    }
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = CGSizeZero;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat contentSizeH = [self.layoutTool getCollectionViewTotalHeight];
        contentSize = CGSizeMake(_collectViewW, contentSizeH);
    }
    else {
        CGFloat contentSizeW = self.layoutTool.collectionViewTotalWidth;
        contentSize = CGSizeMake(contentSizeW, self.collectionView.frame.size.height);
    }
    
    return contentSize;
}



- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArr = [NSMutableArray new];

    CGRect visiableRect = CGRectZero;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;

    
    for (int s = 0; s < _manager.sections.count; s++) {
        JRCollectionViewSection *section = _manager.sections[s];

        if (section.headerItem != nil) {
            UICollectionViewLayoutAttributes *headerAttri = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:s]];
            [attributesArr addObject:headerAttri];
        }
        
        for (int item = 0; item < section.items.count; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:s];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            if (!CGRectIntersectsRect(visiableRect, attributes.frame)) {
                continue;
            }
            [attributesArr addObject:attributes];
        }
        
        
        if (section.footererItem != nil) {
            UICollectionViewLayoutAttributes *footerAttri = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:s]];
            [attributesArr addObject:footerAttri];
        }
    }
    
    return attributesArr;
}

//- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        JRItemFrame *currentFrame = [self.layoutTool queryItemFrameAtSection:itemIndexPath.section item:itemIndexPath.item];
//
//    attributes.transform = CGAffineTransformTranslate(attributes.transform, 0, currentFrame.y);
//    attributes.alpha = 0;
//
//    return attributes;
//}


//
//- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    if (self.deletedItems.count == 0) {
//        return nil;
//    }
//
//    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
//
//    JRItemFrame *currentFrame = [self.layoutTool queryItemFrameAtSection:itemIndexPath.section item:itemIndexPath.item];
//
////    attributes.center = currentFrame.center;
//    attributes.frame = (CGRect){currentFrame.x, currentFrame.y, currentFrame.width, 0};
////    attributes.transform = CGAffineTransformMakeScale(0.4, 0.4);
//    attributes.alpha = 0;
//
//    return attributes;
//}
//


@end




