//
//  UINavigationController+LGStyle.m
//  Legend
//
//  Created by yons on 17/6/8.
//  Copyright © 2017年 congacademy. All rights reserved.
//


#import "UINavigationController+TYNavBarStyle.h"
#import <objc/runtime.h>
#import "UINavigationItem+TYNavBarStyle.h"
#import "UIViewController+TYNavBarStyle.h"
#import "UIView+TYAligmentRectInsets.h"

@interface UINavigationController ()

@end

@implementation UINavigationController (TYNavBarStyle)

#pragma mark ================ 自定义返回按钮  (全局设置) ================

#pragma mark - public

/**
 *  注意：
 *  自定义返回按钮的设置不要在 viewWillAppear 中设置，否则可能会出现返回延迟的现象（搜索页面）
 */
- (void)lg_setNavigationBarBackItemStyle:(TYNavBarStyle)style {
    // 需要设置间距时，自定义按钮
    if ([TYNavBarTintEngine sharedEngine].navBarItemHorizontalMargin > 0.f) {
        [self _lg_setCustomBackItem:style];
        return;
    }
    
    // 将返回按钮上面的文字置空
    if ([TYNavBarTintEngine sharedEngine].backTitleHidden) {
        self.topViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                                   style:UIBarButtonItemStyleDone
                                                                                                  target:nil
                                                                                                  action:nil];
    }
}

#pragma mark - private

- (void)_lg_setCustomBackItem:(TYNavBarStyle)style {
    if (self.childViewControllers.count <= 1 && ![TYNavBarTintEngine sharedEngine].autoCreateBackItemWhenPresent) {
        self.topViewController.navigationItem.leftBarButtonItem = nil;
    } else {
        UIButton *backButton = nil;
        UIImage *backIcon = nil;
        if ([self.topViewController respondsToSelector:@selector(lg_navBarBackItemBackButton)]) {
            backButton = [self.topViewController lg_navBarBackItemBackButton];
            backIcon = backButton.currentImage;
        }
        
        if (!backButton) {
            // 当前控制器自定义返回按钮图片
            if ([self.topViewController respondsToSelector:@selector(lg_navBarBackItemIcon)]) {
                backIcon = [self.topViewController lg_navBarBackItemIcon];
            }
            
            if (backIcon) {
                backButton = [[UIButton alloc] init];
                [backButton addTarget:self
                               action:@selector(_lg_back)
                     forControlEvents:UIControlEventTouchUpInside];
                
                [backButton setImage:backIcon
                            forState:UIControlStateNormal];
                [backButton sizeToFit];
            }
        }
        
        UIBarButtonItem *backItem = nil;
        if (backButton) {
            // 图片显示 tintColor 还是显示本身颜色
            BOOL useTintColor = YES;
            if ([self.topViewController respondsToSelector:@selector(lg_navBarBackItemIconUseTintColor)]) {
                useTintColor = [self.topViewController lg_navBarBackItemIconUseTintColor];
            }
            
            if (useTintColor) {
                backIcon = [backIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [backButton setImage:backIcon forState:UIControlStateNormal];
                
                backButton.titleLabel.font = [[TYNavBarTintEngine sharedEngine] navBarStyleConfig:style].itemFont;
            }
            
            if (CGRectEqualToRect(backButton.frame, CGRectZero)) {
                [backButton sizeToFit];
            }
            
            if ([TYNavBarTintEngine sharedEngine].debugModel) {
                backButton.backgroundColor = [UIColor greenColor];
            }

            backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        } else { // 使用默认配置的返回按钮
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton addTarget:self
                           action:@selector(_lg_back)
                 forControlEvents:UIControlEventTouchUpInside];
            
            if ([TYNavBarTintEngine sharedEngine].backItemConfig) {
                [TYNavBarTintEngine sharedEngine].backItemConfig(backButton);
            }
            backButton.tintColor = [[TYNavBarTintEngine sharedEngine] navBarStyleConfig:style].tintColor;
            backButton.titleLabel.font = [[TYNavBarTintEngine sharedEngine] navBarStyleConfig:style].itemFont;
            
            if (CGRectEqualToRect(backButton.frame, CGRectZero)) {
                [backButton sizeToFit];
            }
            
            backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        }
        
        if (backItem) {
            self.topViewController.navigationItem.leftBarButtonItem = backItem;
        }
    }
}

- (void)_lg_back {
    NSArray *childVcs = self.childViewControllers;
    if (childVcs.count >= 2 && childVcs.lastObject == self.topViewController) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - public

- (void)lg_setNavigationBarStyle:(TYNavBarStyle)style {
    
    self.topViewController.navigationItem.ty_navBarStyle = style;
    TYNavBarStyleConfig *styleConfig = [[TYNavBarTintEngine sharedEngine] navBarStyleConfig:style];
    
    // 导航栏背景色
    if (styleConfig.barTintColor) {
        self.navigationBar.barTintColor = styleConfig.barTintColor;
    }
    
#pragma mark ================ 所有item的主题样式 ================
    
    // 设置导航栏上按钮的颜色
    // 类型一：
    //    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    //    UIBarButtonItem *imgV = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_icon_wechat"] style:UIBarButtonItemStylePlain target:nil action:nil];
    // 无效
    //    [UINavigationBar appearance].tintColor = navItemColor;
    // 有效
    if (styleConfig.tintColor) {
        self.navigationBar.tintColor = styleConfig.tintColor;
    }
    
#pragma mark ================ 控制器标题 ================
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    if (styleConfig.titleColor) {
        attrs[NSForegroundColorAttributeName] = styleConfig.titleColor;
    }
    if (styleConfig.titleFont) {
        attrs[NSFontAttributeName] = styleConfig.titleFont;
    }
    [self.navigationBar setTitleTextAttributes:attrs];
}

@end
