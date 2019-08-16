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
 //是否是点击
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
    // 1.将所有的控制器添加到父控制器中
    for (UIViewController *vc in self.childsVc) {
        [self.parentVc addChildViewController:vc];
    }
    [self addSubview:self.collectionView];
}
// MARK:-  UICollectionViewDataSource&UICollectionViewDelegate  设置UICollectionView的数据源
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childsVc.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 1.获取cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
     // 2.添加view
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
    if (self.isClick) {// 0.判断是否是点击事件
        return;
    }
     // 1.定义获取的数据
    float progress = 0;
       //之前Index
    NSInteger sourceIndex = 0;
     //目标的Index
    NSInteger targetIndex = 0;
     // 2.判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.frame.size.width;
    if (currentOffsetX > self.startOffSexX) { //左滑
           // 1.计算progress
        progress = (CGFloat)currentOffsetX / (CGFloat)scrollViewW - floor(currentOffsetX/scrollViewW);
        // 2.计算sourceIndex
        sourceIndex = (int)(currentOffsetX/scrollViewW);
          // 3.计算targetIndex
        targetIndex = sourceIndex + 1;
        
        if (targetIndex >= self.childsVc.count) {
            targetIndex = self.childsVc.count - 1;
        }
        
         // 4.如果完全划过去
        if (currentOffsetX - self.startOffSexX == scrollViewW) {
            progress = 1.0;
            targetIndex = sourceIndex;
        }
    }else{//右滑
         // 1.计算progress
        progress = 1.0 - (currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW));
        
        // 2.计算tagetIndex
        targetIndex = (int)(currentOffsetX/scrollViewW);
        
        // 3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childsVc.count - 1) {
            sourceIndex = self.childsVc.count - 1;
        }
    }
    NSLog(@"targetIndex=====%ld =====sourceIndex====%ld======= progress=====%f ",targetIndex,(long)sourceIndex,progress);
    // 3.将数据传递给代理
    if ([self.delegate respondsToSelector:@selector(contentViewDidScrollWithProgress:sourceIndex:targetIndex:contentView:)]) {
        [self.delegate contentViewDidScrollWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex contentView:self];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(contentViewEndScroll:)]) {
        [self.delegate contentViewEndScroll:self];
    }
    scrollView.scrollEnabled = YES;
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
    [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

@end
