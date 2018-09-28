//
//  ViewController.m
//  QDBase
//
//  Created by qiaodata100 on 2018/8/6.
//  Copyright © 2018年 qiaodata100. All rights reserved.
//

#import "ViewController.h"
#import "QDDateManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"起一个差不多长的名字";
    [self dataSourceNetRequestWithURLString:@"/sale/list" parameters:@{}];
    
    [self registCellWithCellClassName:@"TestTableViewCell" cellLoadFrom:QDBaseTableViewCellLoadFromNib cellModelClassName:@"NSObject"];
    
    [self useCustomNavigation];
}

- (void)configResultView:(QDRequestResultView *)resultView {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *vc = [ViewController new];
    if (indexPath.row % 2 == 0) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)tapResultView {
    [self.tableView.mj_header beginRefreshing];
}


@end
