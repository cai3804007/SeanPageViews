//
//  SeanPageTitleView.m
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "SeanPageTitleView.h"

@interface SeanPageTitleView()
@property (nonatomic,strong) SeanPageViewStyle *style;
@property (nonatomic,strong) UIScrollView *scrollView;
//底部分割线
@property (nonatomic,strong) UIView *bottomLine;
 //底部滚动条
@property (nonatomic,strong) UIView *lineView;
//遮盖物
@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSMutableArray<UILabel *> *titleLabels;
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) NSArray<NSNumber *> *selectedRGB;
@property (nonatomic,strong) NSArray<NSNumber *> *normalRGB;
@end




@implementation SeanPageTitleView
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(SeanPageViewStyle *)style{
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        _style = style;
        _titleLabels = [NSMutableArray new];
        _currentIndex = 0;
        [self configUI];
        [self creatLabels];
        [self setLabelLocation];
        if (style.isShowBottomLine) {
            [self setupBottomLine];
        }
        if (style.isShowCover) {
            [self setupCoverView];
        }
    }
    
    return self;
}

- (void)configUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    CGFloat h = 0.5;
    _bottomLine.frame = CGRectMake(0, self.frame.size.height - h, self.frame.size.width, h);
    
    _lineView = [UIView new];
    _lineView.backgroundColor = self.style.bottomLineColor;
    
    _coverView = [UIView new];
    _coverView.backgroundColor = self.style.coverBgColor;
    _coverView.alpha = 0.7;
    
    [self addSubview:_scrollView];
    [self addSubview:_bottomLine];
    
}

- (void)creatLabels{
    for (int i = 0; i<_titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        NSString *title = _titles[i];
        label.text = title;
        label.font = self.style.font;
        label.textColor = i == 0 ? self.style.selectedColor : self.style.normalColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tap];
        [_titleLabels addObject:label];
        [self.scrollView addSubview:label];
    }
}

- (void)setLabelLocation{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = 0;
    CGFloat titleH = self.style.titleHeight;
    NSInteger count = self.titles.count;
    for (int i = 0; i< self.titles.count; i++) {
        UILabel *label = self.titleLabels[i];
        if (self.style.isScrollEnable) {
            CGSize size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.style.font} context:nil].size;
            titleW = size.width;
            if (i == 0) {
                titleX = self.style.titleMargin * 0.5;
            }else{
                UILabel *leftLabel = _titleLabels[i - 1];
                titleX = CGRectGetMaxX(leftLabel.frame) + self.style.titleMargin;
            }
        }else{
            titleW = self.frame.size.width/count;
            titleX = titleW * i;
        }
        label.frame = CGRectMake(titleX, titleY, titleW, titleH);
        
        if (i == 0) {
            CGFloat scale = self.style.isNeedScale ? self.style.scaleRange : 1.0;
            label.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    
    if (self.style.isScrollEnable) {
        UILabel *lastLabel = self.titleLabels.lastObject;
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame) + self.style.titleMargin * 0.5, 0);
    }
}

- (void)setupBottomLine{
    [self.scrollView addSubview:self.bottomLine];
    CGRect frame = self.titleLabels.firstObject.frame;
    frame.size.height = self.style.bottomLineH;
    frame.origin.y = self.bounds.size.height - self.style.bottomLineH;
    self.bottomLine.frame = frame;
}

- (void)setupCoverView{
    [self.scrollView bringSubviewToFront:self.coverView];
    UILabel *firstLabel = self.titleLabels.firstObject;
    CGFloat coverW = firstLabel.frame.size.width + self.style.coverMargin * 2;
    CGFloat coverH = self.style.coverH;
    CGFloat coverX = firstLabel.frame.origin.x;
    CGFloat coverY = (self.bounds.size.height - coverH) * 0.5;
    
    if (self.style.isScrollEnable) {
        coverX -= self.style.coverMargin;
        coverW += self.style.coverMargin;
    }
    self.coverView.frame = CGRectMake(coverX, coverY, coverW, coverH);
    self.coverView.center = firstLabel.center;
    self.coverView.layer.cornerRadius = self.style.coverRadius;
    self.coverView.layer.masksToBounds = YES;
}


- (void)titleLabelClick:(UITapGestureRecognizer *)tap{
    UILabel *currentLabel = (UILabel *)[tap view];
    if (self.currentIndex == currentLabel.tag) {return;}
    UILabel *oldLabel = self.titleLabels[self.currentIndex];
    
    oldLabel.textColor = self.style.normalColor;
    currentLabel.textColor = self.style.selectedColor;
    self.currentIndex = currentLabel.tag;
    
    [self.delegate titleViewSelectedIndex:_currentIndex titleView:self];
    [self contenViewDidEndScroll];
    
    if (self.style.isShowBottomLine) {
        CGRect frame = self.bottomLine.frame;
        frame.origin.x = currentLabel.frame.origin.x;
        frame.size.width = currentLabel.frame.size.width;
        [UIView animateWithDuration:0.15 animations:^{
            self.bottomLine.frame = frame;
        }];
    }
    
    if (self.style.isNeedScale) {
        oldLabel.transform = CGAffineTransformIdentity;
        currentLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange, self.style.scaleRange);
    }
    
    if (self.style.isShowCover) {
        CGRect coverFrame = self.coverView.frame;
        coverFrame.size.width = currentLabel.frame.size.width + self.style.coverMargin * 2;
        [UIView animateWithDuration:0.15 animations:^{
            self.coverView.frame = coverFrame;
            self.coverView.center = currentLabel.center;
        }];
    }
    
}

- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    NSArray<NSNumber *> *colorDelta = [self getRGBDeltaWithFirstColor:self.style.selectedColor secondColor:self.style.normalColor];

    sourceLabel.textColor = [[UIColor alloc]initWithRed:self.selectedRGB[0].floatValue - colorDelta[0].floatValue *progress green:self.selectedRGB[1].floatValue - colorDelta[1].floatValue *progress blue:self.selectedRGB[2].floatValue - colorDelta[2].floatValue *progress alpha:1.0];
    
    targetLabel.textColor = [[UIColor alloc]initWithRed:self.selectedRGB[0].floatValue + colorDelta[0].floatValue *progress green:self.selectedRGB[1].floatValue + colorDelta[1].floatValue *progress blue:self.selectedRGB[2].floatValue + colorDelta[2].floatValue *progress alpha:1.0];
    
    self.currentIndex = targetIndex;
    
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveTotalW = targetLabel.frame.size.width - sourceLabel.frame.size.width;
    if (self.style.isShowBottomLine) {
        CGRect bottomFrame = self.bottomLine.frame;
        bottomFrame.size.width = sourceLabel.frame.size.width + moveTotalW * progress;
        bottomFrame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress;
        self.bottomLine.frame = bottomFrame;
    }
    
    if (self.style.isNeedScale) {
        CGFloat scaleDelta = (self.style.scaleRange - 1.0) * progress;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange - scaleDelta * progress, self.style.scaleRange - scaleDelta * progress);
        targetLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange + scaleDelta * progress, self.style.scaleRange + scaleDelta * progress);
    }
    
    if (self.style.isShowCover) {
        CGRect coverFrame = self.coverView.frame;
        coverFrame.size.width = self.style.isScrollEnable ? (sourceLabel.frame.size.width + 2 * self.style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.size.width + moveTotalW * progress);
        coverFrame.origin.x = self.style.isScrollEnable ? (sourceLabel.frame.origin.x - self.style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress);
    }
    
}

- (NSArray<NSNumber *> *)getRGBWithColor:(UIColor *)color{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
     return @[@(red), @(green), @(blue), @(alpha)];
}

- (NSArray<NSNumber *> *)getRGBDeltaWithFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor{
    NSArray<NSNumber *> *RGB1 = [self getRGBWithColor:firstColor];
    NSArray<NSNumber *> *RGB2 = [self getRGBWithColor:secondColor];
   return @[@(RGB1[0].floatValue - RGB2[0].floatValue),@(RGB1[1].floatValue - RGB2[1].floatValue),@(RGB1[2].floatValue - RGB2[2].floatValue)];
}


- (void)contenViewDidEndScroll{
    if (!self.style.isScrollEnable) {
        return;
    }
    UILabel *targetLabel = self.titleLabels[self.currentIndex];
    CGFloat offSetX = targetLabel.center.x - self.bounds.size.width * 0.5;
    if (offSetX < 0) {
        offSetX = 0;
    }
    
    CGFloat maxOffSet = self.scrollView.contentSize.width - self.bounds.size.width;
    if (offSetX > maxOffSet) {
        offSetX = maxOffSet;
    }
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}


-(NSArray *)selectedRGB{
    if (!_selectedRGB) {
        _selectedRGB = [self getRGBWithColor:self.style.selectedColor];
    }
    return _selectedRGB;
}

-(NSArray *)normalRGB{
    if (!_normalRGB) {
        _normalRGB = [self getRGBWithColor:self.style.normalColor];
    }
    return _normalRGB;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/






@end
