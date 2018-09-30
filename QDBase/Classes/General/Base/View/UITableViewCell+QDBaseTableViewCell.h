//
//  UITableViewCell+QDBaseTableViewCell.h
//  QDBase
//
//  Created by QiaoData on 2018/8/8.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// tableViewCell分类，增加indexPath和model

#import <UIKit/UIKit.h>

@interface UITableViewCell (QDBaseTableViewCell)

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSObject *model;
/**
 代码加载cell

 @param tableView 所在的列表
 @param indexPath 所在列表的索引
 @param reuseIdentifier 重用id
 @return UITableViewCell
 */
+ (instancetype)baseTableViewCellLoadFromCodeWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier;
/**
 xib加载cell
 
 @param tableView 所在的列表
 @param indexPath 所在列表的索引
 @param reuseIdentifier 重用id
 @param nibName xib名字
 @return UITableViewCell
 */
+ (instancetype)baseTableViewCellLoadFromNibWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier nibName:(NSString *)nibName;
/**
 storyBoard加载cell
 
 @param tableView 所在的列表
 @param indexPath 所在列表的索引
 @param reuseIdentifier 重用id
 @return UITableViewCell
 */
+ (instancetype)baseTableViewCellLoadFromStoryBoardWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier;

@end
