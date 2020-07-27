//
//  LGTintEngine.m
//  Legend
//
//  Created by againXu on 2017/6/10.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYNavBarTintEngine.h"

TYNavBarStyle const TYNavBarStyleUnset = nil;
TYNavBarStyle const TYNavBarStyleDefault = @"TYNavBarStyleDefault";
TYNavBarStyle const TYNavBarStyleBlue = @"TYNavBarStyleBlue";

@implementation TYNavBarStyleConfig

+ (instancetype)navBarStyleConfigWithTitleColor:(UIColor *)titleColor
                                      titleFont:(nullable UIFont *)titleFont
                                      tintColor:(UIColor *)tintColor
                                       itemFont:(nullable UIFont *)itemFont
                                   barTintColor:(UIColor *)barTintColor
                                 statusBarStyle:(UIStatusBarStyle)statusBarStyle {

    return [[[self class] alloc] initWithTitleColor:titleColor
                                          titleFont:titleFont
                                          tintColor:tintColor
                                           itemFont:itemFont
                                       barTintColor:barTintColor
                                     statusBarStyle:statusBarStyle];
}

- (instancetype)initWithTitleColor:(UIColor *)titleColor
                         titleFont:(nullable UIFont *)titleFont
                         tintColor:(UIColor *)tintColor
                          itemFont:(nullable UIFont *)itemFont
                      barTintColor:(UIColor *)barTintColor
                    statusBarStyle:(UIStatusBarStyle)statusBarStyle {
    self = [super init];
    if (self) {
        _titleColor = titleColor;
        _titleFont = titleFont;
        _tintColor = tintColor;
        _itemFont = itemFont;
        _barTintColor = barTintColor;
        _statusBarStyle = statusBarStyle;
    }
    return self;
}

@end

@interface TYNavBarTintEngine ()

@property (nonatomic, assign) BOOL didSetupDebugView;

@end

@implementation TYNavBarTintEngine

+ (instancetype)engine {
    return [[[self class] alloc] init];
}

static TYNavBarTintEngine *engine_ = nil;

+ (instancetype)createSharedEngine {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine_ = [self engine];
    });
    return engine_;
}

+ (instancetype)sharedEngine {
    return engine_;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _navBarItemHorizontalMargin = 0.f;
        _backTitleHidden = NO;
        _backItemConfig = nil;
        _ignoreConfigNavBarVcClass = @[
            @"ABNewPersonViewController",
            @"CNContactViewHostViewController",
            @"CNContactViewController",
        ];
    }
    return self;
}

- (void)setDebugModel:(BOOL)debugModel {
#ifdef DEBUG
    _debugModel = debugModel;
    if (debugModel && self.navBarItemHorizontalMargin && !self.didSetupDebugView) {
        self.didSetupDebugView = YES;
        [self setupDebugView];
    }
#else
    _debugModel = NO;
#endif
}

- (void)setNavBarItemHorizontalMargin:(CGFloat)navBarItemHorizontalMargin {
    _navBarItemHorizontalMargin = navBarItemHorizontalMargin;
    if (self.debugModel && navBarItemHorizontalMargin && !self.didSetupDebugView) {
        self.didSetupDebugView = YES;
        [self setupDebugView];
    }
}

- (void)setIgnoreConfigNavBarVcClass:(NSArray<NSString *> *)ignoreConfigNavBarVcClass {
    NSMutableArray *ignoreList = [NSMutableArray arrayWithArray:_ignoreConfigNavBarVcClass];
    [ignoreList addObjectsFromArray:ignoreConfigNavBarVcClass];
    _ignoreConfigNavBarVcClass = ignoreList.copy;
}

- (TYNavBarStyleConfig *)navBarStyleConfig:(TYNavBarStyle)style {
    NSAssert(style, @"[error]style 不能为空");
    TYNavBarStyleConfig *config = self.navBarStyleConfigs[style];
    NSAssert(config, @"[error]style(%@) 没有对应的配置信息，请设置", style);
    return config;
}

#pragma mark - private

- (void)setupDebugView {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UILabel *leftMarkLabel = [UILabel new];
    leftMarkLabel.numberOfLines = 0;
    leftMarkLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    leftMarkLabel.text = [NSString stringWithFormat:@"左间距 %.1lf 的位置", self.navBarItemHorizontalMargin];
    [window addSubview:leftMarkLabel];
    [leftMarkLabel sizeToFit];
    CGRect leftFrame = leftMarkLabel.frame;
    leftFrame.origin = CGPointMake(self.navBarItemHorizontalMargin, 10.f);
    leftMarkLabel.frame = leftFrame;

    UILabel *rightMarkLabel = [UILabel new];
    rightMarkLabel.numberOfLines = 0;
    rightMarkLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    rightMarkLabel.text = [NSString stringWithFormat:@"右间距 %.1lf 的位置", self.navBarItemHorizontalMargin];
    [window addSubview:rightMarkLabel];
    [rightMarkLabel sizeToFit];
    CGRect rightFrame = leftMarkLabel.frame;
    rightFrame.origin = CGPointMake(CGRectGetWidth(window.frame) - CGRectGetWidth(rightFrame) - self.navBarItemHorizontalMargin,
                                    10.f);
    rightMarkLabel.frame = rightFrame;
}

@end
