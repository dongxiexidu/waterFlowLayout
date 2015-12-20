//
//  ViewController.m
//  瀑布流
//
//  Created by 李东喜 on 15/12/20.
//  Copyright © 2015年 don. All rights reserved.
//

#import "ViewController.h"
#import "DXWaterFlowLayout.h"
#import "DXCollectionViewCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "DXShop.h"

@interface ViewController ()<UICollectionViewDataSource,DXWaterFlowLayoutDelegate>

@property (nonatomic,weak) UICollectionView *collectionView;
/*** 模型 ***/
@property (nonatomic,strong) NSMutableArray *shops;
@end

@implementation ViewController

static NSString * const shop = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    [self setupRefresh];
}
- (NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [[NSMutableArray alloc] init];
    }
    return _shops;
}

- (void)setupRefresh
{
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
   // self.collectionView.footer.hidden = YES;
    
}

- (void)loadNewShops
{
    sleep(1);
    [self.shops removeAllObjects];
    NSArray *shop = [DXShop objectArrayWithFilename:@"1.plist"];
    [self.shops addObjectsFromArray:shop];
    
    // 刷新数据
    [self.collectionView reloadData];
    [self.collectionView.header endRefreshing];
    
}
- (void)loadMoreShops
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *shops = [DXShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];

        // 刷新数据
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    });
}

- (void)setupLayout
{
    // 创建布局
    DXWaterFlowLayout *layout = [[DXWaterFlowLayout alloc] init];
    layout.delegate = self;
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DXCollectionViewCell class])bundle:nil] forCellWithReuseIdentifier:shop];
}

#pragma mark -<UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shop forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;

}

#pragma mark -------- DXWaterFlowLayoutDelegate---------
- (CGFloat)waterFlowLayout:(DXWaterFlowLayout *)waterFlowLayout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth
{
    DXShop *shop = self.shops[index];
    return shop.h / shop.w * itemWidth;
}

- (CGFloat)columnCountInWaterflowLayout:(DXWaterFlowLayout *)waterflowLayout
{
    if (self.shops.count < 60) return 2;
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(DXWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(20, 30, 40, 100);
}

@end
