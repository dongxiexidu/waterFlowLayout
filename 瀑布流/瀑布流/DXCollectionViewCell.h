//
//  DXCollectionViewCell.h
//  瀑布流
//
//  Created by 李东喜 on 15/12/20.
//  Copyright © 2015年 don. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXShop;
@interface DXCollectionViewCell : UICollectionViewCell
/*** 模型 ***/
@property (nonatomic,strong) DXShop *shop;
@end
