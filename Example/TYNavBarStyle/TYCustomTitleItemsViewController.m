//
//  TYCustomTitleItemsViewController.m
//  TYNavBarStyle_Example
//
//  Created by Tory imac on 2020/6/8.
//  Copyright © 2020 756165690@qq.com. All rights reserved.
//

#import "TYCustomTitleItemsViewController.h"

@interface TYCustomTitleItemsViewController ()

@end

@implementation TYCustomTitleItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.leftBarButtonItems = @[[self createItemWithtitle:@"back"],
                                               [self createItemWithtitle:@"back"],
                                               [self createItemWithtitle:@"back"]];

    self.navigationItem.rightBarButtonItems = @[[self createItemWithtitle:@"back"],
                                                [self createItemWithtitle:@"back"],
                                                [self createItemWithtitle:@"back"]];
}

- (UIBarButtonItem *)createItemWithtitle:(NSString *)title {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(back)];
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
