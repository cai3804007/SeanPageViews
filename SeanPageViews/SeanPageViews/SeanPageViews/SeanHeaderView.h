//
//  SeanHeaderView.h
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/17.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeanHeaderView : UIView
@property (nonatomic, weak) UITableView *tableView;

@property(nonatomic,copy)NSMutableArray *tableViews;
@end

NS_ASSUME_NONNULL_END
