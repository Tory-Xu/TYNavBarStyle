//
//  UINavigationBar+iOS11Spacing.m
//  TYNavBarStyle_Example
//
//  Created by Tory imac on 2020/6/2.
//  Copyright © 2020 756165690@qq.com. All rights reserved.
//

#import "UINavigationBar+iOS11Spacing.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>
#import "UIView+TYAligmentRectInsets.h"



@implementation UINavigationBar (iOS11Spacing)

+(void)load {
    
/**
 // UIBarButtonItem:    initWithTitle
 _UINavigationBarContentView
    -- _UIButtonBarStackView
        -- _UIButtonBarButton
            -- _UIModernBarButton
    
 
 // 系统返回按钮
 _UINavigationBarContentView
    -- _UIButtonBarButton       x: 0
        -- _UIModernBarButton   x: 12
 
*/
    
    
    if (@available(iOS 11, *)) {
        RSSwizzleInstanceMethod(NSClassFromString(@"UINavigationBar"),
                                @selector(layoutSubviews),
                                RSSWReturnType(void),
                                RSSWArguments(),
                                RSSWReplacement({
            
            
            CGFloat offset = 16;

            UIView *view = (UIView *)self;
            // _UINavigationBarContentView
            UIView *barContentView = [UINavigationBar ty_find:view subviewContainStr:@"BarContentView"];
            
//            NSLog(@"setup subviews inset");
            [UINavigationBar ty_resetSubviewsAlignmentRectInsets:barContentView edgeInsets:UIEdgeInsetsMake(0, offset, 0, -offset)];
            
            RSSWCallOriginal();
//            UIView *barContentView = (UIView *)self;

            // _UIButtonBarStackView
//            NSArray<UIView *> *barStackViews = [UINavigationBar ty_find:barContentView subviewsContainStr:@"BarStackView"];
////            NSLog(@"_UIButtonBarStackViews: %@", barStackViews);
//            barStackViews.firstObject.ty_alignmentRectInsetsValue = UIEdgeInsetsMake(0, offset, 0, -offset);
//            if (barStackViews.count > 1) {
//                barStackViews.lastObject.ty_alignmentRectInsetsValue = UIEdgeInsetsMake(0, -offset, 0, offset);
//            }
//
//            // _UIButtonBarButton
//            NSArray<UIView *> *barButtons = [UINavigationBar ty_find:barStackViews.firstObject subviewsContainStr:@"ButtonBarButton"];
//            NSLog(@"barButtons: %@", barButtons);
//            for (UIView *barButton in barButtons) {
//                barButton.ty_alignmentRectInsetsValue = UIEdgeInsetsMake(0, offset, 0, -offset);
//
//                // _UIModernBarButton
//                NSArray<UIView *> *modernBarButtons = [UINavigationBar ty_find:barButton subviewsContainStr:@"ModernBarButton"];
//                NSLog(@"modernBarButtons: %@", modernBarButtons);
//                for (UIView *modernBarButton in modernBarButtons) {
//                    modernBarButton.ty_alignmentRectInsetsValue = UIEdgeInsetsMake(0, offset, 0, -offset);
//
//                    for (UIView *contentView in modernBarButton.subviews) {
//                        contentView.ty_alignmentRectInsetsValue = UIEdgeInsetsMake(0, offset, 0, -offset);
//                    }
//                }
//            }
            
            
            
            
        }), RSSwizzleModeOncePerClass, @selector(layoutSubviews))
    }
}

+ (void)ty_resetSubviewsAlignmentRectInsets:(UIView *)targetView edgeInsets:(UIEdgeInsets)edgeInsets {
    for (UIView *subView in targetView.subviews) {
        
        
        subView.ty_alignmentRectInsetsValue = edgeInsets;
        subView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        
        [UINavigationBar ty_resetSubviewsAlignmentRectInsets:subView edgeInsets:edgeInsets];
    }
}

+ (UIView *)ty_find:(UIView *)target subviewContainStr:(NSString *)str {
   for (UIView *subview in target.subviews) {
      if ([NSStringFromClass([subview class]) containsString:str]) {
          return subview;
      }
    }
    return nil;
}

+ (NSArray<UIView *> *)ty_find:(UIView *)target subviewsContainStr:(NSString *)str {
    NSMutableArray *list = @[].mutableCopy;
   for (UIView *subview in target.subviews) {
      if ([NSStringFromClass([subview class]) containsString:str]) {
          [list addObject:subview];
      }
    }
    return list.copy;
}

@end
