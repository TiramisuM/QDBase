//
//  ViewController.m
//  QDCommentProject
//
//  Created by QiaoData on 2018/8/6.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - ============== LifeCircle ================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    
    self.availableNetWork = NO;
    [self dataSourceNetRequestWithURLString:@"/sale/list" parameters:@{}];
    [self registCellWithCellClassName:@"UITableViewCell" cellLoadFrom:QDBaseTableViewCellLoadFromCode cellModelClassName:@"QDResponseModel"];
    [self useCustomNavigationBarView];
    self.title = @"123";
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
