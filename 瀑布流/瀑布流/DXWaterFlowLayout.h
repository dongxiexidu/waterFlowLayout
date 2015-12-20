

#import <UIKit/UIKit.h>

@class DXWaterFlowLayout;
@protocol DXWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayout:(DXWaterFlowLayout *)waterFlowLayout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(DXWaterFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(DXWaterFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(DXWaterFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(DXWaterFlowLayout *)waterflowLayout;

@end

@interface DXWaterFlowLayout : UICollectionViewLayout

@property (nonatomic,weak) id<DXWaterFlowLayoutDelegate> delegate;
@end
