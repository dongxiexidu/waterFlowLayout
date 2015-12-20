//
//  DXCollectionViewCell.m
//  瀑布流
//
//  Created by 李东喜 on 15/12/20.
//  Copyright © 2015年 don. All rights reserved.
//

#import "DXCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "DXShop.h"

@interface DXCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation DXCollectionViewCell

- (void)setShop:(DXShop *)shop
{
    _shop = shop;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.priceLabel.text = shop.price;
    
}

@end
