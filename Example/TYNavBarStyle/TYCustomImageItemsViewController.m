//
//  TYCustomItemsViewController.m
//  TYNavBarStyle_Example
//
//  Created by Tory imac on 2020/6/1.
//  Copyright © 2020 756165690@qq.com. All rights reserved.
//

#import "TYCustomImageItemsViewController.h"

@interface TYCustomImageItemsViewController ()

@end

@implementation TYCustomImageItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItems = @[[self createItemWithName:@"back"],
                                               [self createItemWithName:@"back"],
                                               [self createItemWithName:@"back"]];

    self.navigationItem.rightBarButtonItems = @[[self createItemWithName:@"back"],
                                                [self createItemWithName:@"back"],
                                                [self createItemWithName:@"back"]];
    
}

- (UIBarButtonItem *)createItemWithName:(NSString *)imageName {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
