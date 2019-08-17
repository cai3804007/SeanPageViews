//
//  SeanPageView.h
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeanPageViewStyle.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SeanPageViewDelegate <NSObject>

- (UITableView *)listScrollView;

@end


@interface SeanPageView : UIView
-(instancetype)initWithFrame:(CGRect)frame style:(SeanPageViewStyle *)style childVcs:(NSArray<UIViewController<SeanPageViewDelegate> *>*)childVcs parentVc:(UIViewController *)parentVc titles:(NSArray *)titles headerView:(UIView *)headerView;
@end

NS_ASSUME_NONNULL_END
