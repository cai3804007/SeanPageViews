//
//  TwoViewController.m
//  PageView
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 yoyochecknow. All rights reserved.
//

#import "TwoViewController.h"
#import "SeanPageView.h"
#import "MJRefresh.h"
@interface TwoViewController ()<UITableViewDelegate,UITableViewDataSource,SeanPageViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) void (^scrollCallback)(UIScrollView *scroll);
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [self tableViewWithTag:2 registerClass:[UITableViewCell class] cellReuseidentifier:@"cell"];
    [self.view addSubview:self.tableView];
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(header)];
}

- (void)header{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}
// MARK: 统一tableView出口
- (UITableView *)tableViewWithTag:(NSInteger)tag registerClass:(nullable Class)cellClass cellReuseidentifier:(NSString *)identifier {
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    frame = frame;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.tag = tag;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    tableView.showsVerticalScrollIndicator = YES;
    [tableView registerClass:cellClass forCellReuseIdentifier:identifier];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.estimatedRowHeight = 100;
    return tableView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld页面,第%ld行",self.view.tag,indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。
 */
- (UIView *)listView {
    return self.view;
}

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
 */
- (UITableView *)listScrollView {
    return self.tableView;
}


/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
