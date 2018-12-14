//
//  ViewController.m
//  QDBase
//
//  Created by QiaoData on 2018/8/6.
//  Copyright © 2018年 QiaoData. All rights reserved.
//

#import "ViewController.h"
#import "QDTableManager.h"
#import "QDTableModel.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - ============== LifeCircle ================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor cyanColor];
    
    [QDTableManager get:nil succeed:^(QDResponseModel *result, BOOL isCache) {
        NSLog(@"%@",result.errorCode);
        NSLog(@"%@",result.message);
    }];
    [self dataSourceNetRequestWithURLString:@"/sale/list" parameters:@{}];
    [self registCellWithCellClassName:@"TestTableViewCell" cellLoadFrom:QDBaseTableViewCellLoadFromNib cellModelClassName:@"NSObject"];
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
