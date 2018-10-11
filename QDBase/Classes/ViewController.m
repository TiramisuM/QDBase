//
//  ViewController.m
//  QDBase
//
//  Created by QiaoData on 2018/8/6.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "ViewController.h"
#import "QDTableAdaper.h"
#import "QDNetWork.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - ============== LifeCircle ================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    
    QDTableAdaper *adaper = [[QDTableAdaper alloc] init];
    adaper.parameter = @{@"keyword":@"王",@"page":@1};
    [adaper requestArraySuccess:^(id result, BOOL isCache) {
        NSLog(@"%@",result);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
//    [adaper requestSuccess:^(id result, BOOL isCache) {
//        NSLog(@"%@",result);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    self.title = @"起一个差不多长的名字";
//
//    [self dataSourceNetRequestWithURLString:@"/sale/list" parameters:@{}];
//    [self registCellWithCellClassName:@"TestTableViewCell" cellLoadFrom:QDBaseTableViewCellLoadFromNib cellModelClassName:@"NSObject"];
//    [self useCustomNavigation];
}

#pragma mark - ============== Construct View ================
- (void)constructView {
    
}

#pragma mark - ============== Data ================

#pragma mark - ============== DataSource & Delegate ================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *vc = [ViewController new];
    if (indexPath.row % 2 == 0) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - ============== Action ================

#pragma mark - ============== PrivateMethod ================
- (void)configResultView:(QDRequestResultView *)resultView {
}

- (void)tapResultView {
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - ============== Setter & Getter ================

@end
