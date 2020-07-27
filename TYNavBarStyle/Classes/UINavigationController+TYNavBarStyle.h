//
//  UINavigationController+TYNavBarStyle.h
//  Legend
//
//  Created by yons on 17/6/8.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYNavBarTintEngine.h"

@interface UINavigationController (TYNavBarStyle)

/**
 *  导航栏颜色，并设置状态栏相应样色
 *
 *  @param style `TYNavBarStyle`
 */
- (void)lg_setNavigationBarStyle:(TYNavBarStyle)style;

/**
 *  导航栏返回按钮样式
 *
 *  如果需要隐藏返回按钮，实现如下：
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 [self.navigationItem setHidesBackButton:YES];
 }
 *
 *  @param style `TYNavBarStyle`
 */
- (void)lg_setNavigationBarBackItemStyle:(TYNavBarStyle)style;

@end
