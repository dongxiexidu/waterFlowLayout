
#import "DXWaterFlowLayout.h"

/** 默认的列数 */
static const NSInteger DXDefaultColumnCount = 3;
/** 默认的列间距 */
static const CGFloat DXDefaultColumnMargin = 10;
/** 默认的行间距 */
static const CGFloat DXDefaultRowMargin = 10;
/** 默认的边缘间距 */
static const UIEdgeInsets DXDefaultUIEdgeInsets = {10,10,10,10};

@interface DXWaterFlowLayout ()
/** 存放所有cell的布局属性 */
@property (nonatomic,strong) NSMutableArray *attrsArray;

/*** 存放所有列的高度(注意包装成对象) ***/
@property (nonatomic,strong) NSMutableArray *columnHeight;
/*** 存放内容高度 ***/
@property (nonatomic,assign) CGFloat contentHeight;

// 方法声明,写方法就会有提示
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation DXWaterFlowLayout

#pragma mark -------- 懒加载---------
- (NSMutableArray *)attrsArray
{
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeight
{
    if (!_columnHeight) {
        _columnHeight = [[NSMutableArray alloc] init];
    }
    return _columnHeight;
}

#pragma mark - 基本数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }else{
        return DXDefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }else{
        return DXDefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    }else{
        return DXDefaultColumnCount;
    }
}
- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    }else{
        return DXDefaultUIEdgeInsets;
    }
}


/* 调用顺序1
 * 调用次数 1
 * 初始化
 */
- (void)prepareLayout
{
    
    self.contentHeight = 0;
    // 清除以前计算的所有高度
    [self.columnHeight removeAllObjects];
    
    for (NSInteger i = 0; i<self.columnCount; i++) {
        [self.columnHeight addObject:@(self.edgeInsets.top)];
    }
    
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    // 开始创建每一个cell对应的布局属性
    // 一共有多少个cell
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i<count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/* 调用顺序 3
 * 调用次数 2
 * 决定cell的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"1111");
   return self.attrsArray;
}

/* 调用顺序 2
 * 调用次数 非常频繁:每加载一个item都会调用1次
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSLog(@"22222");
    // collectionView的宽度
    CGFloat collectViewW = self.collectionView.frame.size.width;
    
    // 设置布局属性的frame
    CGFloat w = (collectViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    
    CGFloat h = [self.delegate waterFlowLayout:self heightForRowAtIndex:indexPath.item itemWidth:w];
    
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    
    CGFloat minColumnHeight = [self.columnHeight[0] doubleValue];
    for (NSInteger i = 1; i<self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeight[i] doubleValue];
        if (columnHeight < minColumnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y = minColumnHeight + self.rowMargin;
    }
    
    attr.frame = CGRectMake(x, y, w, h);
    
    // 更新最短那列的高度
    self.columnHeight[destColumn] = @(CGRectGetMaxY(attr.frame));
    
    CGFloat columnHeight = [self.columnHeight[destColumn] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {

        if (self.contentHeight < columnHeight) {
            self.contentHeight = columnHeight;
        }
    }
    return attr;

}


/* 调用顺序 最后 4
 * 调用次数 2次
 * 返回collectionView可滚动范围
 */
- (CGSize)collectionViewContentSize
{
    NSLog(@"3333");
//    CGFloat maxColumnHeight = [self.columnHeight[0] doubleValue];
//    for (NSInteger i = 1; i < self.columnCount; i++) {
//        // 取得第i列的高度
//        CGFloat columnHeight = [self.columnHeight[i] doubleValue];
//        if (maxColumnHeight < columnHeight) {
//            maxColumnHeight = columnHeight;
//        }
//    }
//
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
