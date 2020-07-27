//
//  UIViewController+TYNavBarStyle.h
//  Legend
//
//  Created by againXu on 2017/6/10.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYNavBarTintEngine.h"

@protocol LGNavigationBarAndstatusBarProtocal <NSObject>

@optional

/**
 *  导航栏和显示样式
 *
 *  @return `TYNavBarStyle`
 */
- (TYNavBarStyle)lg_navigationBarStyle;

#pragma mark - 自定义当前返回按钮，注意：present 出来的第一个控制器需要自己设置返回按钮

/**
 *  设置当前返回按钮，优先级比 lg_navBarBackItemIcon 高
 */
- (UIButton *)lg_navBarBackItemBackButton;

/**
 *  设置当前控制器的返回按钮图标
 */
- (UIImage *)lg_navBarBackItemIcon;

/**
 *  是否使用 tintColor 作为返回按钮图标的颜色，default YES
 *
 *  NO：使用图片的颜色
 *  YES：使用 tintColor，图片的颜色无效
 */
- (BOOL)lg_navBarBackItemIconUseTintColor;

#pragma mark - 状态栏

/**
 *  当前控制器状态栏样式
 */
- (UIStatusBarStyle)lg_statusBarStyle;

@end

@interface UIViewController (TYNavBarStyle) <LGNavigationBarAndstatusBarProtocal>

/**
 *  重置左侧返回按钮
 *
 *  当设置 self.navigationItem.leftBarButtonItem = nil; 时，返回按钮会显示为系统默认返回按钮，因此通过此方法修改为设置的样式
 */
- (void)ty_resetLeftBackItem;

@end



