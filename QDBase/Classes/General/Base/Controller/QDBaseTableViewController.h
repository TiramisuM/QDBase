//
//  QDBaseTableViewController.h
//  QDBase
//
//  Created by QiaoData on 2018/8/6.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 基类tableViewController

#import "QDBaseViewController.h"
#import "QDNetWorkAgent.h"

@class QDResponseModel;
/// cell加载方式
typedef NS_ENUM(NSUInteger, QDBaseTableViewCellLoadFrom) {
    /// 代码中加载cell 默认值
    QDBaseTableViewCellLoadFromCode = 1,
    /// xib中加载cell
    QDBaseTableViewCellLoadFromNib = 2,
    /// storyBoard加载cell
    QDBaseTableViewCellLoadFromStoryBoard = 3
};

/// 基类tableViewController
@interface QDBaseTableViewController : QDBaseViewController <UITableViewDelegate, UITableViewDataSource>

/// 当前页数
@property (nonatomic, assign, readonly) NSInteger currentPage;
/// 请求数据传参页数
@property (nonatomic, assign, readonly) NSInteger paramPage;
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 网络请求是否可用 默认为YES
@property (nonatomic, assign, getter=isAvailableNetWork) BOOL availableNetWork;
/// 是否进入后默认刷新页面 默认为YES
@property (nonatomic, assign) BOOL defaultRefreshPage;
/**
 注册cell 必须调用
 
 @param cellClassName cell的类名
 @param cellLoadFrom cell的加载方式 QDBaseTableViewCellLoadFrom
 @param cellModelClassName model的类名
 */
- (void)registCellWithCellClassName:(NSString *)cellClassName cellLoadFrom:(QDBaseTableViewCellLoadFrom)cellLoadFrom cellModelClassName:(NSString *)cellModelClassName;
/**
 服务器返回的数据
 
 @param responseData 服务器返回的数据
 */
- (void)networkResponseModel:(QDResponseModel *)responseModel;

@end

@interface QDBaseTableViewController (DataSourceRequestParams)
/**
 数据源数据网络请求 默认POST请求 过期时间为120s 缓存策略为"缓存时效内的数据"
 
 @param urlString 请求地址
 @param parameters 请求参数
 */
- (void)dataSourceNetRequestWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters;
/**
 数据源数据网络请求
 
 @param requestType 请求方式 GET/POST QDNetCacheRequestType
 @param urlString 请求地址
 @param parameters 请求参数
 @param cacheTimeout 缓存时效
 @param cachePolicy 缓存策略 QDNetCacheRequestPolicy
 */
- (void)dataSourceNetRequestWithRequestType:(QDNetRequestType)requestType urlString:(NSString *)urlString parameters:(NSDictionary *)parameters cacheTimeout:(NSUInteger)cacheTimeout cachePolicy:(QDNetCacheRequestPolicy)cachePolicy;

/**
 更新请求参数
 
 @param parameters 完整的请求参数
 */
- (void)updateParameters:(NSDictionary *)parameters;

@end
