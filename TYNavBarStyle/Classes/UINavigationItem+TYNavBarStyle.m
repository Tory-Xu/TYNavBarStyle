//
//  UINavigationItem+TYCustomStyle.m
//  NavigationBar
//
//  Created by Tory imac on 2019/10/10.
//  Copyright © 2019 yang_0921. All rights reserved.
//

#import "UINavigationItem+TYNavBarStyle.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>

#import "UIView+TYAligmentRectInsets.h"

NS_INLINE CGFloat _ty_defaultMargin() {
    // leftBarButtonItem/rightBar ButtonItem 和边缘的原始距离
    CGFloat defaultMargin = 16.f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        defaultMargin = 20.f;
    } else if (@available(iOS 13, *)) {
        defaultMargin = 20.f;
    }
    return defaultMargin;
}

@implementation UIBarButtonItem (TYNavBarStyle)

#pragma mark - helper

/// 有标题，
- (BOOL)_ty_isSystemItem {
    if (self.title || self.customView || self.image) {
        return NO;
    }
    return YES;
}

@end

@implementation UINavigationItem (TYNavBarStyle)

+ (void)load {
    static char const *const kNavBarStyleSetLeftBarButtonItemKey = "navBarStyleSetLeftBarButtonItem";

    RSSwizzleInstanceMethod([UINavigationItem class],
                            @selector(setLeftBarButtonItem:animated:),
                            RSSWReturnType(void),
                            RSSWArguments(UIBarButtonItem * item, BOOL animated),
                            RSSWReplacement({
                                if (item) {
                                    [self setLeftBarButtonItems:@[item] animated:animated];
                                    return;
                                }
        
                                RSSWCallOriginal(item, animated);
                            }),
                            RSSwizzleModeOncePerClass, kNavBarStyleSetLeftBarButtonItemKey);

    static char const *const kNavBarStyleSetLeftBarButtonItemsKey = "navBarStyleSetLeftBarButtonItems";
    RSSwizzleInstanceMethod([UINavigationItem class],
                            @selector(setLeftBarButtonItems:animated:),
                            RSSWReturnType(void),
                            RSSWArguments(NSArray<UIBarButtonItem *> * items, BOOL animated),
                            RSSWReplacement({

                                UINavigationItem *navigationItem = (UINavigationItem *) self;
                                // 不修改间距且 || 样式为变化
                                if (items.count == 0 || [TYNavBarTintEngine sharedEngine].navBarItemHorizontalMargin == 0.f || TYNavBarStyeIsEqual(navigationItem.ty_navBarStyle, TYNavBarStyleUnset)) {
                                    RSSWCallOriginal(items, animated);
                                    return;
                                }

                                BOOL isAllCustomItem = YES;
                                for (UIBarButtonItem *item in items) {
                                    if ([item _ty_isSystemItem]) {
                                        isAllCustomItem = NO;
                                        break;
                                    }
                                }
                                // items 都是系统按钮时
                                if (!isAllCustomItem) {
                                    RSSWCallOriginal(items, animated);
                                    return;
                                }

                                NSArray<UIBarButtonItem *> *leftBarButtonItems = [self _ty_createCustomItemsWithItem:items
                                                                                                              isLeft:YES]
                                                                                     .mutableCopy;
                                RSSWCallOriginal(leftBarButtonItems, animated);

                            }),
                            RSSwizzleModeOncePerClass, kNavBarStyleSetLeftBarButtonItemsKey);

    static char const *const kNavBarStyleSetRightBarButtonItemKey = "navBarStyleSetRightBarButtonItem";
    RSSwizzleInstanceMethod([UINavigationItem class],
                            @selector(setRightBarButtonItem:animated:),
                            RSSWReturnType(void),
                            RSSWArguments(UIBarButtonItem * item, BOOL animated),
                            RSSWReplacement({
                                if (item) {
                                    [self setRightBarButtonItems:@[item] animated:animated];
                                    return;
                                }
                                RSSWCallOriginal(item, animated);
                            }),
                            RSSwizzleModeOncePerClass, kNavBarStyleSetRightBarButtonItemKey);

    static char const *const kNavBarStyleSetRightBarButtonItemsKey = "navBarStyleSetRightBarButtonItems";
    RSSwizzleInstanceMethod([UINavigationItem class],
                            @selector(setRightBarButtonItems:animated:),
                            RSSWReturnType(void),
                            RSSWArguments(NSArray<UIBarButtonItem *> * items, BOOL animated),
                            RSSWReplacement({
                                UINavigationItem *navigationItem = (UINavigationItem *) self;
                                if (items.count == 0 || [TYNavBarTintEngine sharedEngine].navBarItemHorizontalMargin == 0.f || TYNavBarStyeIsEqual(navigationItem.ty_navBarStyle, TYNavBarStyleUnset)) {
                                    RSSWCallOriginal(items, animated);
                                    return;
                                }

                                BOOL isAllCustomItem = YES;
                                for (UIBarButtonItem *item in items) {
                                    if ([item _ty_isSystemItem]) {
                                        isAllCustomItem = NO;
                                        break;
                                    }
                                }
                                // items 都是系统按钮时
                                if (!isAllCustomItem) {
                                    RSSWCallOriginal(items, animated);
                                    return;
                                }

                                NSArray<UIBarButtonItem *> *rightBarButtonItems = [self _ty_createCustomItemsWithItem:items
                                                                                                               isLeft:NO]
                                                                                      .mutableCopy;

                                RSSWCallOriginal(rightBarButtonItems, animated);
                            }),
                            RSSwizzleModeOncePerClass, kNavBarStyleSetRightBarButtonItemsKey);
}

#pragma mark - private

/// 创建自定义 item
/// @param item 系统 item 不支持，只支持 customView，title，image 样式的 item
- (UIBarButtonItem *)_ty_createCustomItem:(UIBarButtonItem *)item
                                   isLeft:(BOOL)isLeft {
    UIBarButtonItem *customItem = nil;
    UIView *customView = item.customView;
    if (customView) {
        [customView sizeToFit];
        customItem = item;
    } else if (item.image || item.title) {
        UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [barButton setImage:item.image
                   forState:UIControlStateNormal];
        [barButton setTitle:item.title
                   forState:UIControlStateNormal];
        UIColor *tintColor = [[TYNavBarTintEngine sharedEngine] navBarStyleConfig:self.ty_navBarStyle].tintColor;
        [barButton setTitleColor:tintColor forState:UIControlStateNormal];
        
        [barButton sizeToFit];
        [barButton addTarget:item.target
                      action:item.action
            forControlEvents:UIControlEventTouchUpInside];
        customView = barButton;

        customItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    } else { // 系统类型按钮
        NSAssert(NO, @"系统 item 不能作为参数传入");
    }

    // Note: iOS 11 以上设备需要设置约束，否则下面的 -alignmentRectInsets 方法不会被调用
    if (@available(iOS 11, *)) {
        if (customView.translatesAutoresizingMaskIntoConstraints) {
            customView.translatesAutoresizingMaskIntoConstraints = NO;
            [customView.widthAnchor constraintEqualToConstant:CGRectGetWidth(customView.frame)].active = YES;
            [customView.heightAnchor constraintEqualToConstant:44].active = YES;
        }
    }

    CGFloat leftOffset = _ty_defaultMargin() - [TYNavBarTintEngine sharedEngine].navBarItemHorizontalMargin;
    if (isLeft) {
        customView.ty_alignmentRectInsetsValue = UIEdgeInsetsMake(0, leftOffset, 0, -leftOffset);
    } else {
        customView.ty_alignmentRectInsetsValue = UIEdgeInsetsMake(0, -leftOffset, 0, leftOffset);
    }

    if ([TYNavBarTintEngine sharedEngine].debugModel) {
        customView.backgroundColor = [UIColor greenColor];
    }

    return customItem;
}

- (NSArray<UIBarButtonItem *> *)_ty_createCustomItemsWithItem:(NSArray<UIBarButtonItem *> *)items
                                                       isLeft:(BOOL)isLeft {

    NSMutableArray *customItems = [NSMutableArray array];
    for (UIBarButtonItem *item in items) {
        UIBarButtonItem *customItem = [self _ty_createCustomItem:item isLeft:isLeft];
        if (customItem) {
            [customItems addObject:customItem];
        }
    }

    // iOS 13 需要添加间距，否则 UIButton 会超出父视图，在侧滑返回过程超出部分在屏幕上无法显示
    if (@available(iOS 11, *)) {
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
        CGFloat leftOffset = _ty_defaultMargin() - [TYNavBarTintEngine sharedEngine].navBarItemHorizontalMargin;
        spacer.width = leftOffset;
        if (isLeft) {
            [customItems insertObject:spacer atIndex:0];
        } else {
            [customItems addObject:spacer];
        }
    }

    return customItems;
}

- (void)_ty_changeImageRenderingMode:(UIView *)customView {
    if (!self.ty_navBarStyle) {
        return;
    }

    TYNavBarStyleConfig *styleConfig = [[TYNavBarTintEngine sharedEngine] navBarStyleConfig:self.ty_navBarStyle];
    if ([customView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *) customView;
        //        [self _ty_changButton:btn imageRenderingModeForState:UIControlStateNormal];
        //        [self _ty_changButton:btn imageRenderingModeForState:UIControlStateHighlighted];
        //        [self _ty_changButton:btn imageRenderingModeForState:UIControlStateDisabled];

        // 只对字号进行修改
        if (styleConfig.itemFont) {
            btn.titleLabel.font = [UIFont fontWithName:btn.titleLabel.font.fontName
                                                  size:styleConfig.itemFont.pointSize];
            ;
        }
        if (styleConfig.tintColor) {
            [btn setTitleColor:styleConfig.tintColor
                      forState:UIControlStateNormal];
        }
    } else if ([customView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *) customView;
        if (imageView.image && imageView.image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }

    for (UIView *subView in customView.subviews) {
        [self _ty_changeImageRenderingMode:subView];
    }
}

- (void)_ty_changButton:(UIButton *)btn imageRenderingModeForState:(UIControlState)state {
    UIImage *image = [btn imageForState:state];
    if (image && image.renderingMode != UIImageRenderingModeAlwaysOriginal) {
        [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
             forState:state];
    }
}

#pragma mark - setter & getter

- (void)setTy_navBarStyle:(TYNavBarStyle)ty_navBarStyle {
    objc_setAssociatedObject(self, @selector(ty_navBarStyle), ty_navBarStyle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TYNavBarStyle)ty_navBarStyle {
    return objc_getAssociatedObject(self, _cmd);
}

@end
