//
//  UIView+TYAligmentRectInsets.m
//  NavigationBar
//
//  Created by Tory imac on 2019/10/10.
//  Copyright © 2019 yang_0921. All rights reserved.
//

#import "UIView+TYAligmentRectInsets.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>

//#import <TYSwizzle/NSObject+TYSwizzleOnce.h>

@implementation UIView (TYAligmentRectInsets)

//static UIEdgeInsets ty_alignmentRectInsets(UIButton *self, SEL _cmd) {
//
//    if (!UIEdgeInsetsEqualToEdgeInsets(self.ty_alignmentRectInsetsValue, UIEdgeInsetsZero)) {
//        return self.ty_alignmentRectInsetsValue;
//    }
//    Class superClass = class_getSuperclass(object_getClass(self));
//    IMP superClassMethodImp = [superClass instanceMethodForSelector:_cmd];
//    NSAssert(superClassMethodImp, @"父类方法实现指针获取不到");
//
//    if (superClassMethodImp) {
//        UIEdgeInsets insets = ((UIEdgeInsets (*)(id,SEL))superClassMethodImp)(self, _cmd);
//        return insets;
//    }
//    return UIEdgeInsetsZero;
//}

#pragma mark - getter & setter

/**
 NOTE: UIButton 重写了 UIView 的 -alignmentRectInsets 方法，并且没有调用父类方法，
 所以对 UIView 的 -alignmentRectInsets 方法交换并不能对 UIButton 起到效果，因此 UIView 和 UIButton 都需要进行一次方法交换
 */
+ (void)load {
    static char const * const kNavBarStyleALigmentRectInsetsKey = "navBarStyleALigmentRectInsetsKey";
    RSSwizzleInstanceMethod([UIView class],
                            @selector(alignmentRectInsets),
                            RSSWReturnType(UIEdgeInsets),
                            RSSWArguments(),
                            RSSWReplacement({
        UIView *view = (UIView *)self;

        if (!UIEdgeInsetsEqualToEdgeInsets(view.ty_alignmentRectInsetsValue, UIEdgeInsetsZero)) {
            return view.ty_alignmentRectInsetsValue;
        }
        return RSSWCallOriginal();

    }), RSSwizzleModeOncePerClass, kNavBarStyleALigmentRectInsetsKey);
    
    RSSwizzleInstanceMethod([UIButton class],
                            @selector(alignmentRectInsets),
                            RSSWReturnType(UIEdgeInsets),
                            RSSWArguments(),
                            RSSWReplacement({
        UIButton *button = (UIButton *)self;
        
        if (!UIEdgeInsetsEqualToEdgeInsets(button.ty_alignmentRectInsetsValue, UIEdgeInsetsZero)) {
            return button.ty_alignmentRectInsetsValue;
        }
        return RSSWCallOriginal();
        
    }), RSSwizzleModeOncePerClass, kNavBarStyleALigmentRectInsetsKey);
}

- (void)setTy_alignmentRectInsetsValue:(UIEdgeInsets)ty_alignmentRectInsetsValue {
    objc_setAssociatedObject(self,
                             @selector(ty_alignmentRectInsetsValue),
                             [NSValue valueWithUIEdgeInsets:ty_alignmentRectInsetsValue],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100
//    [self ty_swizzleInstanceMethod:@selector(alignmentRectInsets)
//                           inClass:[self class]
//                               imp:(IMP)ty_alignmentRectInsets
//                             types:"UIEdgeInsets@:"];
}

- (UIEdgeInsets)ty_alignmentRectInsetsValue {
    NSValue *insetsValue = objc_getAssociatedObject(self, _cmd);
    if (insetsValue) {
        return [insetsValue UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

@end
