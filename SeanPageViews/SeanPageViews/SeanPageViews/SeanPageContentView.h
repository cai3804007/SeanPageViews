//
//  SeanPageContentView.h
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SeanPageContentView;
@protocol SeanPageContentViewDelegate<NSObject>

- (void)contentViewDidScrollWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex contentView:(SeanPageContentView *)contentView;
@optional
- (void)contentViewEndScroll:(SeanPageContentView *)contentView;

@end



@interface SeanPageContentView : UIView
@property (nonatomic,weak) id<SeanPageContentViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray<UIViewController *> *)childVcs parentVc:(UIViewController *)parentVc;
//移动到指定位置
- (void)setCurrentIndex:(NSInteger)currentIndex;
@end

NS_ASSUME_NONNULL_END
