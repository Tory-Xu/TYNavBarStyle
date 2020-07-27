//
//  LGTintEngine.h
//  Legend
//
//  Created by againXu on 2017/6/10.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *TYNavBarStyle;

/** 未设置 */
UIKIT_EXTERN TYNavBarStyle const TYNavBarStyleUnset;
/** 自定义默认样式 */
UIKIT_EXTERN TYNavBarStyle const TYNavBarStyleDefault;
UIKIT_EXTERN TYNavBarStyle const TYNavBarStyleBlue;

NS_INLINE BOOL TYNavBarStyeIsEqual(TYNavBarStyle style1, TYNavBarStyle style2) {
    if (style1 == nil && style2 == nil) {
        return YES;
    }
    if (style2 == nil) {
        return NO;
    }
    return [style1 isEqualToString:style2];
}

typedef void (^LGTintEngineBackItemConfig)(UIButton *backButton);

@interface TYNavBarStyleConfig : NSObject

/** 导航栏标题颜色 */
@property (nonatomic, strong) UIColor *titleColor;

/** 导航栏标题字体 */
@property (nonatomic, strong) UIFont *titleFont;

/** item 风格样色 */
@property (nonatomic, strong) UIColor *tintColor;

/** item 字体 */
@property (nonatomic, strong) UIFont *itemFont;

/** 导航栏背景色 */
@property (nonatomic, strong) UIColor *barTintColor;

/** 状态栏样式
 *  注意：在 info.plist 文件中添加 `View controller-based status bar appearance` ，并设为 `NO` 才能生效
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/// 设置导航栏样式
/// @param titleColor 标题颜色
/// @param titleFont 标题字体大小
/// @param tintColor 按钮颜色
/// @param itemFont 按钮字体大小
/// @param barTintColor 导航栏背景色
/// @param statusBarStyle 样式
+ (instancetype)navBarStyleConfigWithTitleColor:(nullable UIColor *)titleColor
                                      titleFont:(nullable UIFont *)titleFont
                                      tintColor:(nullable UIColor *)tintColor
                                       itemFont:(nullable UIFont *)itemFont
                                   barTintColor:(nullable UIColor *)barTintColor
                                 statusBarStyle:(UIStatusBarStyle)statusBarStyle;

@end

@interface TYNavBarTintEngine : NSObject

+ (instancetype)createSharedEngine;

+ (instancetype)sharedEngine;

#pragma mark - 返回按钮设置

/** 不显示返回按钮上的标题，default YES */
@property (nonatomic, assign) BOOL backTitleHidden;

/** 配置返回按钮样式，如果已经设置了 backItem，那么 backItemConfig 不会再调用 */
@property (nonatomic, copy) LGTintEngineBackItemConfig backItemConfig;

/** 导航栏上 item 左边和右边的间距，最小值为12.f */
@property (nonatomic, assign) CGFloat navBarItemHorizontalMargin;

/// present 时自动生成返回按钮，default NO
@property (nonatomic, assign) BOOL autoCreateBackItemWhenPresent;

/** 需要忽略处理的控制器类型 */
@property (nonatomic, copy) NSArray<NSString *> *ignoreConfigNavBarVcClass;

/** 测试模式，图片添加背景色便于查看，default NO */
@property (nonatomic, assign) BOOL debugModel;

#pragma mark - 导航栏样式

/** 导航栏样式配置信息 */
@property (nonatomic, strong) NSDictionary<TYNavBarStyle, TYNavBarStyleConfig *> *navBarStyleConfigs;

/** 通过当前样式获取导航栏样式配置 */
- (TYNavBarStyleConfig *)navBarStyleConfig:(TYNavBarStyle)style;

@end

NS_ASSUME_NONNULL_END
