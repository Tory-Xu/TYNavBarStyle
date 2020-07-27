# TYNavBarStyle

[![CI Status](https://img.shields.io/travis/756165690@qq.com/TYNavBarStyle.svg?style=flat)](https://travis-ci.org/756165690@qq.com/TYNavBarStyle)
[![Version](https://img.shields.io/cocoapods/v/TYNavBarStyle.svg?style=flat)](https://cocoapods.org/pods/TYNavBarStyle)
[![License](https://img.shields.io/cocoapods/l/TYNavBarStyle.svg?style=flat)](https://cocoapods.org/pods/TYNavBarStyle)
[![Platform](https://img.shields.io/cocoapods/p/TYNavBarStyle.svg?style=flat)](https://cocoapods.org/pods/TYNavBarStyle)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TYNavBarStyle is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TYNavBarStyle'
```


## 功能

1. 修改导航栏自定义按钮位置
2. 自定义返回按钮

## 使用


```
+ (void)configNavBarStyle {
    TYNavBarTintEngine *tintEngine = [TYNavBarTintEngine createSharedEngine];
    tintEngine.debugModel = YES;
    tintEngine.navBarItemHorizontalMargin = DTNavBarMargin;
    [tintEngine setBackItemConfig:^(UIButton *backButton) {
        UIImage *backImage = [UIImage ty_imageWithIcon:DTIconfontNavBack
                                              fontSize:24.f
                                             tintColor:[UIColor blackColor]];
        [backButton setImage:backImage forState:UIControlStateNormal];
        return YES;
    }];
    
    // 过滤系统页面
    tintEngine.ignoreConfigNavBarVcClass = @[@"ABNewPersonViewController",
                                             @"CNContactViewHostViewController",
                                             @"CNContactViewController",];
    TYNavBarStyleConfig *defaultConfig = [TYNavBarStyleConfig navBarStyleConfigWithTitleColor:[UIColor defaultNavBarTitleColor]
                                                                                    titleFont:nil
                                                                                    tintColor:[UIColor defaultNavBarTextColor]
                                                                                     itemFont:nil
                                                                                 barTintColor:[UIColor defaultNavBarBackgroundColor]
                                                                               statusBarStyle:UIStatusBarStyleDefault];
    tintEngine.navBarStyleConfigs = @{TYNavBarStyleDefault: defaultConfig};
}
```

## Author

756165690@qq.com, 756165690@qq.com

## License

TYNavBarStyle is available under the MIT license. See the LICENSE file for more info.
