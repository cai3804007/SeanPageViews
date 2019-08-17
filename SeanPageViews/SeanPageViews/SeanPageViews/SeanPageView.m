//
//  SeanPageView.m
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "SeanPageView.h"
#import "SeanPageTitleView.h"
#import "SeanPageContentView.h"
@interface SeanPageView ()<SeanPageTitleViewDelegate,SeanPageContentViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) SeanPageViewStyle *style;
@property (nonatomic,strong) NSArray<UIViewController<SeanPageViewDelegate> *> *childVcs;
@property (nonatomic,strong) UIViewController *parentVc;
@property (nonatomic,strong) SeanPageTitleView *titleView;
@property (nonatomic,strong) SeanPageContentView *pageContentView;

@property (nonatomic,strong) UIScrollView *contentScrollView;

@property (nonatomic,strong) UIView *header;

@property (nonatomic,assign) CGFloat lastTableViewOffsetY;
@property (nonatomic,strong) UITableView *currentTableView;
@property (nonatomic,assign) NSInteger currentIndex;
@end


@implementation SeanPageView

-(instancetype)initWithFrame:(CGRect)frame style:(SeanPageViewStyle *)style childVcs:(NSArray<UIViewController<SeanPageViewDelegate> *>*)childVcs parentVc:(UIViewController *)parentVc titles:(NSArray *)titles headerView:(UIView *)headerView{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.childVcs = childVcs;
        self.parentVc = parentVc;
        self.titles = titles;
        _header = headerView;
        [self configUI];
    }
    return self;
}

- (void)configUI{
//    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
//    _contentScrollView = scrollView;
//    scrollView.delegate = self;
//    [self addSubview:scrollView];
    
    CGRect titleFrame = CGRectMake(0, self.header.frame.size.height, self.frame.size.width, self.style.titleHeight);
    self.titleView = [[SeanPageTitleView alloc]initWithFrame:titleFrame titles:self.titles style:self.style];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.delegate = self;
    _currentIndex = _titleView.currentIndex;
    
    CGRect contentFrame = CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height);
    self.pageContentView = [[SeanPageContentView alloc]initWithFrame:contentFrame childVcs:self.childVcs parentVc:self.parentVc];
    self.pageContentView.delegate = self;
    [self addSubview:self.pageContentView];
    [self addSubview:self.titleView];
    if (self.style.isNeedHeader) {
        [self addSubview:self.header];
        for (UIViewController<SeanPageViewDelegate> *page in self.childVcs) {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.header.frame.size.height + self.style.titleHeight)];
            page.listScrollView.tableHeaderView = header;
            page.listScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(self.header.frame.size.height - self.style.titleHeight , 0, 0, 0);
             NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
            [page.listScrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
        }
    }
}


- (void)changeOtherTableViewLastContent{
    for (UIViewController<SeanPageViewDelegate> *page in self.childVcs) {\
        UITableView *tableView = page.listScrollView;
        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=self.header.frame.size.height) {
            
            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
            
        }else if(  self.lastTableViewOffsetY < 0){
            
            tableView.contentOffset = CGPointMake(0, 0);
            
        }else if ( self.lastTableViewOffsetY > self.header.frame.size.height){
            
            tableView.contentOffset = CGPointMake(0, self.header.frame.size.height);
        }
    }
}

//- (void)changeClickItemTableViewLastContent{
//    self.currentTableView  = ;
//    for (UITableView *tableView in self.tableViews) {
//
//        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=136) {
//
//            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
//
//        }else if(self.lastTableViewOffsetY < 0){
//
//            tableView.contentOffset = CGPointMake(0, 0);
//
//        }else if ( self.lastTableViewOffsetY > 136){
//
//            tableView.contentOffset = CGPointMake(0, 136);
//        }
//    }
//}






#pragma observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UITableView *tableView = (UITableView *)object;
    
    if (!(self.currentTableView == tableView)) {
        return;
    }
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    NSLog(@"%f",tableView.contentOffset.y);
    self.lastTableViewOffsetY = tableViewoffsetY;
    
    if ( tableViewoffsetY>=0 && tableViewoffsetY<= self.header.frame.size.height) {
         self.header.frame = CGRectMake(0, -tableViewoffsetY, self.frame.size.width,self.header.frame.size.height);
    }else if( tableViewoffsetY < 0 ){
         self.header.frame = CGRectMake(0, -tableViewoffsetY, self.frame.size.width, self.header.frame.size.height);
    }else if (tableViewoffsetY > self.header.frame.size.height){
        self.header.frame = CGRectMake(0, -self.header.frame.size.height, self.frame.size.width, self.header.frame.size.height);
    }
    self.titleView.frame = CGRectMake(0, CGRectGetMaxY(self.header.frame), self.titleView.frame.size.width, self.titleView.frame.size.height);
    
}



#pragma SeanPageContentViewDelegate
-(void)contentViewDidScrollWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex contentView:(SeanPageContentView *)contentView{
    self.currentIndex = targetIndex;
    [self.titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    if (self.style.isNeedHeader) {
        [self changeOtherTableViewLastContent];
    }
}

-(void)contentViewEndScroll:(SeanPageContentView *)contentView{
    [self.titleView contenViewDidEndScroll];
  
}

#pragma SeanPageTitleViewDelegate
- (void)titleViewSelectedIndex:(NSInteger)index titleView:(nonnull SeanPageTitleView *)titleView {
    [self.pageContentView setCurrentIndex:index];
    if (self.style.isNeedHeader) {
        self.currentIndex = index;
        self.currentTableView = [self.childVcs[index] listScrollView];
        [self changeOtherTableViewLastContent];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.style.isNeedHeader) {
//        NSLog(@"scrollView.contentOffset=======%f",scrollView.contentOffset.y);
//        if (scrollView.contentOffset.y < self.header.frame.size.height) {
//            scrollView.userInteractionEnabled = YES;
//            self.contentView.userInteractionEnabled = NO;
//        }else{
//            scrollView.userInteractionEnabled = NO;
//            self.contentView.userInteractionEnabled = YES;
//        }
//    }
}
-(UITableView *)currentTableView{
    return [self.childVcs[_currentIndex] listScrollView];
}

-(void)dealloc{
   
    for (UIViewController<SeanPageViewDelegate> *page in self.childVcs) {
        [page.listScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
}

@end
