//
//  UIViewController+TYNavBarStyle.m
//  Legend
//
//  Created by againXu on 2017/6/10.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "UIViewController+TYNavBarStyle.h"

#import "TYNavBarTintEngine.h"
#import "UINavigationController+TYNavBarStyle.h"

#import <RSSwizzle/RSSwizzle.h>

@implementation UIViewController (TYNavBarStyle)

static char const * const kNavBarStyleViewDidLoad = "navBarStyleViewDidLoad";
static char const * const kNavBarStyleViewWillAppear = "navBarStyleViewWillAppear";

+ (void)load {
    SEL viewDidLoadSel = @selector(viewDidLoad);
    [RSSwizzle swizzleInstanceMethod:viewDidLoadSel
                          inClass:[UIViewController class]
                    newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
                      
                      return ^(__unsafe_unretained UIViewController *self) {
                        
                          void(^originalIMPBlock)(__unsafe_unretained UIViewController *self) = ^(__unsafe_unretained UIViewController *self) {
                              void (*originalIMP)(__unsafe_unretained id, SEL);
                              originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
                              originalIMP(self, viewDidLoadSel);
                          };
                          
                          // 是导航栏控制器或者没有导航栏，不处理
                          if ([self isKindOfClass:[UINavigationController class]] ||
                              self.navigationController == nil
                              || ![TYNavBarTintEngine sharedEngine]) {
                              originalIMPBlock(self);
                              return;
                          }
                          
                          [self _lg_setNavBarStyle];
                          
                          /**
                           *  导航栏透明度设置为不透明。此时 self.view 从 (0, 64) 点开始
                           *  不建议这么做：
                           *          当某个页面需要透明效果，其它页面不需要时，处理就会比较麻烦
                           */
                          //        self.navigationController.navigationBar.translucent = NO;
                          originalIMPBlock(self);
                          
                      };
                    } mode:RSSwizzleModeOncePerClass key:kNavBarStyleViewDidLoad];
    
    SEL viewWillAppearSel = @selector(viewWillAppear:);
    [RSSwizzle swizzleInstanceMethod:viewWillAppearSel
                             inClass:[UIViewController class]
                       newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
                           
                           return ^(__unsafe_unretained UIViewController *self, BOOL animated) {
                               
                               void(^originalIMPBlock)(__unsafe_unretained UIViewController *self, BOOL animated) = ^(__unsafe_unretained UIViewController *self, BOOL animated) {
                                   void (*originalIMP)(__unsafe_unretained id, SEL, BOOL);
                                   originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
                                   originalIMP(self, viewWillAppearSel, animated);
                               };
                               
                               // 是导航栏控制器或者没有导航栏，不处理
                               if ([self isKindOfClass:[UINavigationController class]] ||
                                   self.navigationController == nil
                                   || ![TYNavBarTintEngine sharedEngine]) {
                                   originalIMPBlock(self, animated);
                                   return;
                               }
                               
                               TYNavBarStyle style = [self _lg_getNavBarStyle];
                               if (!TYNavBarStyeIsEqual(TYNavBarStyleUnset, style)) {
                                   [self.navigationController lg_setNavigationBarStyle:style];
                                   if ([self respondsToSelector:@selector(lg_statusBarStyle)]) {
                                       [UIApplication sharedApplication].statusBarStyle = [self lg_statusBarStyle];
                                   } else if ([self respondsToSelector:@selector(_lg_statusBarStyle:)]) {
                                       [UIApplication sharedApplication].statusBarStyle = [self _lg_statusBarStyle:style];
                                   }
                               }
                               
                               originalIMPBlock(self, animated);
                           };
                           
                       } mode:RSSwizzleModeOncePerClass key:kNavBarStyleViewWillAppear];
}

#pragma mark - public

- (void)ty_resetLeftBackItem {
    UINavigationController *nav = self.navigationController;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)self;
    }
    TYNavBarStyle style = [self _lg_getNavBarStyle];
    [nav lg_setNavigationBarBackItemStyle:style];
}

#pragma mark - private

/**
 *  状态栏样式
 *
 *  @param style 导航栏样式
 *
 *  @return 状态栏样式
 */
- (UIStatusBarStyle)_lg_statusBarStyle:(TYNavBarStyle)style {
    return [[TYNavBarTintEngine sharedEngine] navBarStyleConfig:style].statusBarStyle;
}

- (void)_lg_setNavBarStyle {
    TYNavBarStyle style = [self _lg_getNavBarStyle];
    if (!TYNavBarStyeIsEqual(TYNavBarStyleUnset, style)) {
        [self.navigationController lg_setNavigationBarStyle:style];
        [self.navigationController lg_setNavigationBarBackItemStyle:style];
    }
}

- (TYNavBarStyle)_lg_getNavBarStyle {
    TYNavBarStyle style = TYNavBarStyleDefault;
    if ([self respondsToSelector:@selector(lg_navigationBarStyle)]) {
        style = [self lg_navigationBarStyle];
    }

    // 调整到的系统页面不处理
    NSArray<NSString *> *ignoreConfigNavBarVcClass = [TYNavBarTintEngine sharedEngine].ignoreConfigNavBarVcClass;
    if ([ignoreConfigNavBarVcClass containsObject:NSStringFromClass([self class])]) {
        style = TYNavBarStyleUnset;
    }
    return style;
}

@end
