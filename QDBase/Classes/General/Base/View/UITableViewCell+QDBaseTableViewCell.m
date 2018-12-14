//
//  UITableViewCell+QDBaseTableViewCell.m
//  QDBase
//
//  Created by QiaoData on 2018/8/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// tableViewCell分类，增加indexPath和model

#import "UITableViewCell+QDBaseTableViewCell.h"
#import <objc/runtime.h>

const void *kBaseTableCellIndexPathKey = @"kBaseTableCellIndexPathKey";
const void *kBaseTableCellModelKey = @"kBaseTableCellModelKey";

@implementation UITableViewCell (QDBaseTableViewCell)

+ (instancetype)baseTableViewCellLoadFromCodeWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
    return [self baseTableViewCellLoadFromCodeWithTableView:tableView indexPath:indexPath reuseIdentifier:reuseIdentifier cellClassName:reuseIdentifier];
}

+ (instancetype)baseTableViewCellLoadFromCodeWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier cellClassName:(NSString *)cellClassName {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        Class class = NSClassFromString(cellClassName);
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.indexPath = indexPath;
    return cell;
}

+ (instancetype)baseTableViewCellLoadFromNibWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier nibName:(NSString *)nibName {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
    }
    cell.indexPath = indexPath;
    return cell;
}

+ (instancetype)baseTableViewCellLoadFromStoryBoardWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}


- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, kBaseTableCellIndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setModel:(NSObject *)model {
    objc_setAssociatedObject(self, kBaseTableCellModelKey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, kBaseTableCellIndexPathKey);
}

- (NSObject *)model {
    return objc_getAssociatedObject(self, kBaseTableCellModelKey);
}

@end
