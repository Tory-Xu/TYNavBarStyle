//
//  TYViewControllerTest1.m
//  TYNavBarStyle_Example
//
//  Created by Tory imac on 2020/1/21.
//  Copyright © 2020 756165690@qq.com. All rights reserved.
//

#import "TYViewControllerTest1.h"
#import <Masonry/Masonry.h>
#import "UIView+TYAligmentRectInsets.h"

#import "UIViewController+TYNavBarStyle.h"

@interface TYViewControllerTest1 ()

@end

@implementation TYViewControllerTest1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"test1";
    self.view.backgroundColor = [UIColor whiteColor];

//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *backImage = [UIImage imageNamed:@"Feedback_l"];
//    [button setImage:backImage
//            forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"reset left items" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor blueColor];
    [button1 addTarget:self action:@selector(resetLeftItems) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(100);
    }];
}

- (void)resetLeftItems {
    [self ty_resetLeftBackItem];
}

@end
