//
//  TYCustomViewItemsViewController.m
//  TYNavBarStyle_Example
//
//  Created by Tory imac on 2020/6/8.
//  Copyright © 2020 756165690@qq.com. All rights reserved.
//

#import "TYCustomViewItemsViewController.h"

@interface TYCustomViewItemsViewController ()

@end

@implementation TYCustomViewItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItems = @[[self createItemWithImageName:@"back"],
                                               [self createItemWithImageName:@"back"],
                                               [self createItemWithImageName:@"back"]];

    self.navigationItem.rightBarButtonItems = @[[self createItemWithImageName:@"back"],
                                                [self createItemWithImageName:@"back"],
                                                [self createItemWithImageName:@"back"]];
}

- (UIBarButtonItem *)createItemWithImageName:(NSString *)imageName {
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:imageName];
    imgV.frame = CGRectMake(100, 100, 40, 40);

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return backItem;
}

- (void)back {
    NSArray *childVcs = self.navigationController.childViewControllers;
    if (childVcs.count >= 2 && childVcs.lastObject == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
