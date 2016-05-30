//
//  ViewController.m
//  YKAFNExtension
//
//  Created by 凯 on 16/5/30.
//  Copyright © 2016年 凯. All rights reserved.
//

#import "ViewController.h"
#import "YKDataTaskManger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsOnline) {
        NSLog(@"有网");
    }else
    {
        NSLog(@"没网");
    }
    if (IsMobileNetwork) {
        NSLog(@"是3G");
    }
    else
    {
        NSLog(@"不是3G");
    }
    if (IsWifi) {
        NSLog(@"是WiFi");
    }
    else
    {
        NSLog(@"不是WiFi");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
