//
//  TYViewController.m
//  TYNavBarStyle
//
//  Created by 756165690@qq.com on 10/11/2019.
//  Copyright (c) 2019 756165690@qq.com. All rights reserved.
//

#import "TYViewController.h"
#import "TYViewControllerTest1.h"
#import "TYCustomTitleItemsViewController.h"
#import "TYCustomImageItemsViewController.h"
#import "TYCustomViewItemsViewController.h"

@interface TYViewController ()

@end

@implementation TYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"标题";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"title"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftAction)];

    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"back"];
    imgV.frame = CGRectMake(100, 100, 40, 40);
    [self.view addSubview:imgV];
}

- (void)leftAction {
    TYViewControllerTest1 *vc = [[TYViewControllerTest1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)present:(id)sender {
    TYViewControllerTest1 *vc = [TYViewControllerTest1 new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)push:(id)sender {
    [self.navigationController pushViewController:[TYViewControllerTest1 new] animated:YES];
}

- (IBAction)pushToCustomViewItems:(id)sender {
    [self.navigationController pushViewController:[TYCustomViewItemsViewController new] animated:YES];
}

- (IBAction)pushToImageItemVc:(id)sender {
    [self.navigationController pushViewController:[TYCustomImageItemsViewController new] animated:YES];
}

- (IBAction)pushToTitleItemVc:(id)sender {
    [self.navigationController pushViewController:[TYCustomTitleItemsViewController new] animated:YES];
}

@end
