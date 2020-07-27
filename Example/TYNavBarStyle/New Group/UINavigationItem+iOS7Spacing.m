//
//  UINavigationItem+iOS7Spacing.m
//  TYNavBarStyle_Example
//
//  Created by Tory imac on 2020/6/2.
//  Copyright © 2020 756165690@qq.com. All rights reserved.
//

#import "UINavigationItem+iOS7Spacing.h"
#import <objc/runtime.h>
 
#define xSpacerWidth -8
 
@implementation UINavigationItem (iOS7Spacing)
 
- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = xSpacerWidth;
    return space;
}
 
- (void)mk_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (@available(iOS 11, *)) {
        [self mk_setLeftBarButtonItem:leftBarButtonItem];
    } else if (@available(iOS 7, *)) {
        if (leftBarButtonItem && (leftBarButtonItem.customView !=nil || leftBarButtonItem.image !=nil)) {
            [self mk_setLeftBarButtonItem:nil];
            [self mk_setLeftBarButtonItems:@[[self spacer], leftBarButtonItem]];
        } else {
            if (@available(iOS 7, *)) {
                [self mk_setLeftBarButtonItems:nil];
            }
            [self mk_setLeftBarButtonItem:leftBarButtonItem];
        }
    } else {
        [self mk_setLeftBarButtonItem:leftBarButtonItem];
    }
}
 
- (void)mk_setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    if (@available(iOS 7, *) && leftBarButtonItems && leftBarButtonItems.count > 0 ) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:leftBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:leftBarButtonItems];
        
        [self mk_setLeftBarButtonItems:items];
    } else {
        [self mk_setLeftBarButtonItems:leftBarButtonItems];
    }
}
 
- (void)mk_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if (@available(iOS 7, *)) {
        [self mk_setRightBarButtonItem:rightBarButtonItem];
    } else if (@available(iOS 7, *)) {
        if (rightBarButtonItem && (rightBarButtonItem.customView !=nil || rightBarButtonItem.image != nil)) {
            [self mk_setRightBarButtonItem:nil];
            [self mk_setRightBarButtonItems:@[[self spacer], rightBarButtonItem]];
        } else {
            if (@available(iOS 7, *)) {
                [self mk_setRightBarButtonItems:nil];
            }
            [self mk_setRightBarButtonItem:rightBarButtonItem];
        }
    } else {
        [self mk_setRightBarButtonItem:rightBarButtonItem];
    }
}
 
- (void)mk_setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    if (@available(iOS 7, *) && rightBarButtonItems && rightBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:rightBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:rightBarButtonItems];
        
        [self mk_setRightBarButtonItems:items];
    } else {
        [self mk_setRightBarButtonItems:rightBarButtonItems];
    }
}
 
+ (void)mk_swizzle:(SEL)aSelector
{
    SEL bSelector = NSSelectorFromString([NSString stringWithFormat:@"mk_%@", NSStringFromSelector(aSelector)]);
    
    Method m1 = class_getInstanceMethod(self, aSelector);
    Method m2 = class_getInstanceMethod(self, bSelector);
    
    method_exchangeImplementations(m1, m2);
}
 
+ (void)load
{
    [self mk_swizzle:@selector(setLeftBarButtonItem:)];
    [self mk_swizzle:@selector(setLeftBarButtonItems:)];
    [self mk_swizzle:@selector(setRightBarButtonItem:)];
    [self mk_swizzle:@selector(setRightBarButtonItems:)];
}

@end
