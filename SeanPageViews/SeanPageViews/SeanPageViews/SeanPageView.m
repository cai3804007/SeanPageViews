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
@interface SeanPageView ()<SeanPageTitleViewDelegate,SeanPageContentViewDelegate>
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) SeanPageViewStyle *style;
@property (nonatomic,strong) NSArray<UIViewController *> *childVcs;
@property (nonatomic,strong) UIViewController *parentVc;
@property (nonatomic,strong) SeanPageTitleView *titleView;
@property (nonatomic,strong) SeanPageContentView *contentView;
@end


@implementation SeanPageView

-(instancetype)initWithFrame:(CGRect)frame style:(SeanPageViewStyle *)style childVcs:(NSArray<UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.childVcs = childVcs;
        self.parentVc = parentVc;
        self.titles = titles;
        [self configUI];
    }
    return self;
}

- (void)configUI{
    CGRect titleFrame = CGRectMake(0, 0, self.frame.size.width, self.style.titleHeight);
    self.titleView = [[SeanPageTitleView alloc]initWithFrame:titleFrame titles:self.titles style:self.style];
    self.titleView.delegate = self;
    [self addSubview:self.titleView];
    
    CGRect contentFrame = CGRectMake(0, self.style.titleHeight, self.bounds.size.width, self.bounds.size.height - self.style.titleHeight);
    self.contentView = [[SeanPageContentView alloc]initWithFrame:contentFrame childVcs:self.childVcs parentVc:self.parentVc];
    self.contentView.delegate = self;
    [self addSubview:self.contentView];
}


#pragma SeanPageContentViewDelegate
-(void)contentViewDidScrollWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex contentView:(SeanPageContentView *)contentView{
    [self.titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}

-(void)contentViewEndScroll:(SeanPageContentView *)contentView{
    [self.titleView contenViewDidEndScroll];
}

#pragma SeanPageTitleViewDelegate
- (void)titleViewSelectedIndex:(NSInteger)index titleView:(nonnull SeanPageTitleView *)titleView {
    [self.contentView setCurrentIndex:index];
}


@end
