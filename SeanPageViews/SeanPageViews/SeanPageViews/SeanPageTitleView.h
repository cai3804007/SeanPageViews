//
//  SeanPageTitleView.h
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeanPageViewStyle.h"
NS_ASSUME_NONNULL_BEGIN
@class SeanPageTitleView;
@protocol SeanPageTitleViewDelegate<NSObject>
- (void)titleViewSelectedIndex:(NSInteger)index titleView:(SeanPageTitleView *)titleView;

@end
@interface SeanPageTitleView : UIView

@property (readonly) NSInteger currentIndex;
@property (nonatomic,weak) id<SeanPageTitleViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(SeanPageViewStyle *)style;
- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
- (void)contenViewDidEndScroll;

@end

NS_ASSUME_NONNULL_END
