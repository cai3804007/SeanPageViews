//
//  SeanHeaderView.m
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/17.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "SeanHeaderView.h"

@implementation SeanHeaderView




- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    for (UITableView *tableView in self.tableViews) {
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    }
}

@end
