//
//  ViewController.m
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "ViewController.h"
#import "SeanPageView.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

#import "MJRefresh.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *titles = @[@"热agg门",@"爆1dgdsg笑",@"11afgag1",@"最afgf热",@"最afg",@"最好afg",@"最凉afg",@"最1111afg"];
//    SeanPageViewStyle *style = [[SeanPageViewStyle alloc]init];
//    style.scaleRange = 1.2;
//    style.isNeedScale = YES;
//    style.isScrollEnable = YES;
//    style.isShowBottomLine = YES;
//    style.isShowCover = YES;
//    style.isNeedHeader = YES;
//    CGRect pageViewFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
//
//    NSMutableArray *vcs = [NSMutableArray new];
//    OneViewController *one = [[OneViewController alloc]init];
//
//    TwoViewController *two = [[TwoViewController alloc]init];
//    ThreeViewController *three = [[ThreeViewController alloc]init];
//
//    ThreeViewController *four = [[ThreeViewController alloc]init];
//
//    TwoViewController *five = [[TwoViewController alloc]init];
//     TwoViewController *six = [[TwoViewController alloc]init];
//     TwoViewController *seven = [[TwoViewController alloc]init];
//     TwoViewController *eight = [[TwoViewController alloc]init];
//    one.view.tag = 1;
//    two.view.tag = 2;
//    three.view.tag = 3;
//    four.view.tag = 4;
//    five.view.tag = 5;
//     six.view.tag = 6;
//     seven.view.tag = 7;
//     eight.view.tag = 8;
//    [vcs addObject:one];
//    [vcs addObject:two];
//    [vcs addObject:three];
//    [vcs addObject:four];
//    [vcs addObject:five];
//    [vcs addObject:six];
//    [vcs addObject:seven];
//    [vcs addObject:eight];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    imageView.backgroundColor = [UIColor redColor];
//    SeanPageView *page = [[SeanPageView alloc]initWithFrame:pageViewFrame style:style childVcs:vcs parentVc:self titles:titles headerView:imageView];
//    [self.view addSubview:page];
    
    NSArray *titles = @[@"最新作品",@"优秀作品"];
    SeanPageViewStyle *style = [[SeanPageViewStyle alloc]init];
    style.isShowBottomLine = YES;
    style.isNeedHeader = YES;
    style.isBottomLineFull = NO;
    CGRect pageViewFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    NSMutableArray *vcs = [NSMutableArray new];
    OneViewController *one = [[OneViewController alloc]init];
    
    TwoViewController *two = [[TwoViewController alloc]init];

    one.view.tag = 1;
    two.view.tag = 2;

    [vcs addObject:one];
    [vcs addObject:two];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    imageView.backgroundColor = [UIColor redColor];
    SeanPageView *page = [[SeanPageView alloc]initWithFrame:pageViewFrame style:style childVcs:vcs parentVc:self titles:titles headerView:imageView];
    [self.view addSubview:page];
    
//    one.tableView.mj_header.frame = CGRectMake(0,200-56, self.view.frame.size.width, 56);
//    [one.tableView.tableHeaderView addSubview:one.tableView.mj_header];
    
}


@end
