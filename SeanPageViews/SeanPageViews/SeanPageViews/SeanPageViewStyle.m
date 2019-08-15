//
//  SeanPageViewStyle.m
//  SeanPageViews
//
//  Created by yoyochecknow on 2019/8/15.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "SeanPageViewStyle.h"
#import "ImportConstants.h"
@implementation SeanPageViewStyle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initStyle];
    }
    return self;
}

- (void)initStyle{
    _isScrollEnable = NO;
    _normalColor = RGB_COLOR(0, 0, 0);
    _selectedColor = RGB_COLOR(255, 127, 0);
    _font = [UIFont systemFontOfSize:15];
    _titleMargin = 20;
    _titleHeight = 44;
    _isShowBottomLine = NO;
    _bottomLineColor = [UIColor orangeColor];
    _bottomLineH = 2;
    _isNeedScale = NO;
    _scaleRange = 1.2;
    _isShowCover = NO;
    _coverBgColor = [UIColor lightGrayColor];
    _coverMargin = 5;
    _coverH = 25;
    _coverRadius = 12;
}


@end
