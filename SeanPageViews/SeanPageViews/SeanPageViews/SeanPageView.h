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

@interface SeanPageView : UIView
-(instancetype)initWithFrame:(CGRect)frame style:(SeanPageViewStyle *)style childVcs:(NSArray<UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc titles:(NSArray *)titles;
@end

NS_ASSUME_NONNULL_END
