//
//  SeanPageContentView.m
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "SeanPageContentView.h"

@interface SeanPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray<UIViewController *> *childsVc;
@property (nonatomic,weak) UIViewController *parentVc;
@property (nonatomic,assign) BOOL isClick;
@property (nonatomic,assign) CGFloat startOffSexX;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation SeanPageContentView
- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray<UIViewController *> *)childVcs parentVc:(UIViewController *)parentVc{
    if (self = [super initWithFrame:frame]) {
        self.childsVc = childVcs;
        self.parentVc = parentVc;
        [self configUI];
        [self configSubViews];
    }
    return self;
}

- (void)configUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = self.bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.scrollsToTop = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
}

- (void)configSubViews{
    for (UIViewController *vc in self.childsVc) {
        [self.parentVc addChildViewController:vc];
    }
    [self addSubview:self.collectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childsVc.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIViewController *vc = self.childsVc[indexPath.item];
    vc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:vc.view];
    return cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isClick = NO;
    self.startOffSexX = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isClick) {
        return;
    }
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.frame.size.width;
    if (currentOffsetX > self.startOffSexX) {
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX/scrollViewW);
        sourceIndex = (int)(currentOffsetX/scrollViewW);
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childsVc.count) {
            targetIndex = self.childsVc.count - 1;
        }
        if (currentOffsetX - self.startOffSexX == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    }else{
        progress = 1 - (currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW));
        targetIndex = (int)(currentOffsetX/scrollViewW);
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= targetIndex + 1) {
            sourceIndex = self.childsVc.count - 1;
        }
                
        if ([self.delegate respondsToSelector:@selector(contentViewDidScrollWithProgress:sourceIndex:targetIndex:contentView:)]) {
            [self.delegate contentViewDidScrollWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex contentView:self];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(contentViewEndScroll:)]) {
        [self.delegate contentViewEndScroll:self];
        scrollView.scrollEnabled = YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        if ([self.delegate respondsToSelector:@selector(contentViewEndScroll:)]) {
            [self.delegate contentViewEndScroll:self];
        }
    }else{
        scrollView.scrollEnabled = NO;
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    self.isClick = YES;
    CGFloat offsetX = currentIndex * self.collectionView.frame.size.width;
    [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
}

@end
