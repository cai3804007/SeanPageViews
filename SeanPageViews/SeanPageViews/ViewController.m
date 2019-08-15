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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titles = @[@"热门",@"爆笑",@"看看谁最美呢你看一看啊",@"最热",@"最新"];
    SeanPageViewStyle *style = [[SeanPageViewStyle alloc]init];
    style.isScrollEnable = YES;
    style.isShowBottomLine = YES;
    style.isShowCover = YES;
    
    CGRect pageViewFrame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    NSMutableArray *vcs = [NSMutableArray new];
    OneViewController *one = [[OneViewController alloc]init];
    TwoViewController *two = [[TwoViewController alloc]init];
    ThreeViewController *three = [[ThreeViewController alloc]init];
    
    ThreeViewController *four = [[ThreeViewController alloc]init];
    
    TwoViewController *five = [[TwoViewController alloc]init];
    [vcs addObject:one];
    [vcs addObject:two];
    [vcs addObject:three];
    [vcs addObject:four];
    [vcs addObject:five];
    
    SeanPageView *page = [[SeanPageView alloc]initWithFrame:pageViewFrame style:style childVcs:vcs parentVc:self titles:titles];
    [self.view addSubview:page];
    
}


@end
