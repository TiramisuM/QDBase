//
//  QDBaseTableViewController.m
//  QDBase
//
//  Created by QiaoData on 2018/8/6.
//  Copyright © 2018年 QiaoData. All rights reserved.
/// 基类tableViewController

#import "QDBaseTableViewController.h"
#import "NSObject+QDBaseModel.h"
#import "QDRefreshHeader.h"
#import "QDRefreshFooter.h"
#import "UITableViewCell+QDBaseTableViewCell.h"
#import "QDTableModel.h"

// 请求参数
static NSString  *const  kParamPageSize = @"pageSize";
static NSString  *const  kParamMinID    = @"minId";
static NSString  *const  kParamPage     = @"page";
// 每页请求多少条数据
static NSUInteger const  PageSize       = 20;

@interface QDBaseTableViewController ()
{
    // dataSource基础数据请求参数
    QDNetRequestType _requestType;
    NSString *_urlString;
    NSDictionary *_parameters;
    NSUInteger _cacheTimeout;
    QDNetCacheRequestPolicy _cachePolicy;
}

/// 当前页数
@property (nonatomic, assign) NSInteger currentPage;
/// 请求数据传参页数
@property (nonatomic, assign) NSInteger paramPage;
/// 上一个加载的id
@property (nonatomic,   copy) NSString *lastId;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// cell的类名
@property (nonatomic, copy) NSString *cellClassName;
/// cell的加载方式 不设置则为默认从代码中加载
@property (nonatomic, assign) QDBaseTableViewCellLoadFrom cellLoadFrom;
/// model的类名
@property (nonatomic, copy) NSString *modelClassName;

@end

@implementation QDBaseTableViewController

#pragma mark - ============== LifeCircle ================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    [self configDefaultValue];
    // 添加刷新控件
    [self addRefresh];
    // 开始请求数据
    [self.tableView.mj_header beginRefreshing];
    
}

// 初始化数据
- (void)configDefaultValue {
    // 将一些简单的数据初始化
    self.currentPage = 0;
    self.paramPage = 0;
    self.lastId = @"";
    self.cellLoadFrom = QDBaseTableViewCellLoadFromCode;
    // 显示空页面
    self.responseDataState = QDNetworkRequstResultStateEmpty;
}

// 添加下拉刷新上拉加载的控件
- (void)addRefresh {
    // 给tableView添加下拉刷新、上拉加载的方法
    self.tableView.mj_header = [QDRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [QDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreData)];
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - ============== Data ================

#pragma mark 加载数据
- (void)loadData {
    // 将传参的paramPage设置为1
    self.paramPage = 1;
    // 重置footer的状态
    [self.tableView.mj_footer resetNoMoreData];
    // 请求数据
    [self baseRequestData];
}

- (void)addMoreData {
    
    // 将当前的页数赋值给传参的页数
    self.paramPage = self.currentPage + 1;
    
    [self baseRequestData];
}

- (void)baseRequestData {
    
    // 将page和minId拼接到参数中
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_parameters];
//    if (self.paramPage != 1) params[kParamMinID] = self.lastId;
//    params[kParamPage] = @(self.paramPage);
//    params[kParamPageSize] = @(PageSize);
//    NSAssert(_urlString, @"必须调用\"[self dataSourceNetRequest...]\"方法");
//
//    // 判断当前缓存机制是否为 "有缓存就先返回缓存，同步请求数据" , 如果是，则继续判断是否为第一页，不是第一页的话 忽略缓存直接请求
//    QDNetCacheRequestPolicy cachePolicy = _cachePolicy;
//    if (cachePolicy == QDNetCacheRequestReturnCacheDataThenLoad && self.paramPage != 1) {
//        cachePolicy = QDNetCacheRequestReloadIgnoringCacheData;
//    }
//
//    NSURLSessionDataTask *dataTask = [QDNetworkWithCache requestWithType:_requestType
//                                                                     urlString:_urlString
//                                                                    parameters:params
//                                                                  cacheTimeout:_cacheTimeout
//                                                                   cachePolicy:cachePolicy
//                                                                      progress:nil
//                                                                       success:^(id result, BOOL isCache) {
//                                                                           [self responseSuccessDataWithObject:result isCache:isCache];
//                                                                       } failure:^(NSError *error) {
//                                                                           [self responseFailureDataWithError:error];
//                                                                       }];
//    [self addURLSessionDataTask:dataTask];
}

#pragma mark 服务器返回的数据
- (void)responseSuccessDataWithObject:(id)responseObject isCache:(BOOL)isCache {
    
    // 是否需要忽略缓存，等到有真实请求数据才结束头部刷新
    BOOL ignoreCache = (_cachePolicy == QDNetCacheRequestReturnCacheDataThenLoad && isCache);
    // 结束头部刷新
    if (!ignoreCache) [self.tableView.mj_header endRefreshing];
    
    // 拿到errorCode
    NSString *errorCode = judgeString(responseObject[@"error"]);
    
    if (errorCode.integerValue != 0) {
        
        if (self.dataSource.count == 0) self.responseDataState = QDNetworkRequstResultStateError;
        if (!ignoreCache) [self.tableView.mj_footer endRefreshing];
        
        return;
    }
    
    // 将数据赋值给临时数组
    NSMutableArray *tempArr = [self generateModelsWithResponseObject:responseObject[@"data"]];
    // 将数据抛给子类，让子类做一些其他操作
    [self networkResponseData:responseObject[@"data"]];
    // 判断赋值之后的数组有无数据
    if (tempArr.count == 0) {
        
        // 将mj_footer更改为无数据状态
        // 不能用self.currentPage == 1判断。 若当前页面已有数据。进行下拉刷新，此时没有返回数据，但我们的数组没有清空，如果直接变成Empty页面用户体验不好
        if (self.dataSource.count == 0) {
            self.responseDataState = QDNetworkRequstResultStateEmpty;
            self.tableView.mj_footer.hidden = YES;
        }
        if (!ignoreCache) [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
        
    } else if (tempArr.count < PageSize) {
        // 将mj_footer更改为NoMoreData状态
        if (!ignoreCache) [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        if (!ignoreCache) [self.tableView.mj_footer endRefreshing];
    }
    
    // 根据传参页数判断是否将dataSource清空
    if (self.paramPage == 1) [self.dataSource removeAllObjects];
    // 将服务器返回的数据添加到dataSource后面
    [self.dataSource addObjectsFromArray:tempArr];
    // 页数
    self.currentPage = self.paramPage;
    // 记录最后一条数据的id
    self.lastId = [self minIdWithModel:self.dataSource.lastObject];
    // 回调刷新界面
    self.responseDataState = QDNetworkRequstResultStateSuccess;
    [self.tableView reloadData];
    
    self.tableView.mj_footer.hidden = self.dataSource.count ? NO : YES;
}

- (void)responseFailureDataWithError:(NSError *)error {
    if (!self.dataSource.count) {
        // 显示错误页面
        if (error.code == -1009) {
            // 显示无网络页面
            self.responseDataState = QDNetworkRequstResultStateNoNet;
        } else if (error.code == -999) {
            // 取消请求 主动触发taskCancelled
        } else {
            self.responseDataState = QDNetworkRequstResultStateError;
        }
    }
    // 结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark 将服务器返回的数据包装成需要的model类型，之后返回model数组
- (NSMutableArray *)generateModelsWithResponseObject:(id)responseObject {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    Class class = NSClassFromString(self.modelClassName);
    NSAssert(class, @"必须调用\"[self registCellWithCellClassName:cellLoadFrom:cellModelClassName:]\"方法");
    tempArray = [class mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
    return tempArray;
}

#pragma mark 设置minId
- (NSString *)minIdWithModel:(NSObject *)model {
    return model.id;
}

#pragma mark - ============== 子类实现代码 ================
#pragma mark 网络请求回调数据
- (void)networkResponseData:(id)responseData {}

#pragma mark - ============== 子类调用方法 ================
- (void)registCellWithCellClassName:(NSString *)cellClassName cellLoadFrom:(QDBaseTableViewCellLoadFrom)cellLoadFrom cellModelClassName:(NSString *)cellModelClassName {
    
    self.cellClassName = [judgeString(cellClassName) isEqualToString:@""] ? @"UITableViewCell" :cellClassName;
    self.cellLoadFrom = cellLoadFrom;
    self.modelClassName = [judgeString(cellModelClassName) isEqualToString:@""] ? @"NSObject" : cellModelClassName;
}


#pragma mark - ============== Delegate ================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!IS_NOT_EMPTY(self.cellClassName)) {
        NSLog(@"error: 请在子类实现 tableView:cellForRowAtIndexPath:");
        return nil;
    }
    Class class = NSClassFromString(self.cellClassName);
    NSAssert(class, @"必须调用\"[self registCellWithCellClassName:cellLoadFrom:cellModelClassName:]\"方法");
    NSAssert([class isSubclassOfClass:[UITableViewCell class]], @"cell类必须继承自UITableViewCell");
    NSString *reuseIdentifier = self.cellClassName;
    UITableViewCell *cell;
    
    // 根据加载方式选择相应的初始化方法
    switch (self.cellLoadFrom) {
        case QDBaseTableViewCellLoadFromCode:
            cell = [UITableViewCell baseTableViewCellLoadFromCodeWithTableView:tableView indexPath:indexPath reuseIdentifier:reuseIdentifier];
            break;
            
        case QDBaseTableViewCellLoadFromNib:
            cell = [UITableViewCell baseTableViewCellLoadFromNibWithTableView:tableView indexPath:indexPath reuseIdentifier:self.cellClassName nibName:reuseIdentifier];
            break;
            
        case QDBaseTableViewCellLoadFromStoryBoard:
            cell = [UITableViewCell baseTableViewCellLoadFromStoryBoardWithTableView:tableView indexPath:indexPath reuseIdentifier:reuseIdentifier];
            break;
            
        default:
            NSAssert(self.cellLoadFrom > 0 && self.cellLoadFrom < 4, @"必须传cell的加载方式");
            break;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - ============== Lazy ================
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT + UI_STATUS_BAR_HEIGHT, kScreenWidth, kScreenHeight - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_BOTTOM_SAFE_HEIGHT);
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end

@implementation QDBaseTableViewController (DataSourceRequestParams)

- (void)dataSourceNetRequestWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters {
    _requestType = QDNetRequestTypePOST;
    _urlString = urlString;
    _parameters = parameters;
    _cacheTimeout = 120.f;
    _cachePolicy = QDNetCacheRequestTimestampLoad;
}

- (void)dataSourceNetRequestWithRequestType:(QDNetRequestType)requestType urlString:(NSString *)urlString parameters:(NSDictionary *)parameters cacheTimeout:(NSUInteger)cacheTimeout cachePolicy:(QDNetCacheRequestPolicy)cachePolicy {
    _requestType = requestType;
    _urlString = urlString;
    _parameters = parameters;
    _cacheTimeout = cacheTimeout;
    _cachePolicy = cachePolicy;
}

@end
