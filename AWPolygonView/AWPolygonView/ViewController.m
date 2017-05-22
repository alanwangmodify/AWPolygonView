//
//  ViewController.m
//  AWPolygonView
//
//  Created by AlanWang on 17/3/21.
//  Copyright © 2017年 AlanWang. All rights reserved.
//

#import "ViewController.h"
#import "AWPolygonView.h"
#import "ShowViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    


    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(100, 400, 50, 50);
    [btn addTarget:self action:@selector(starAnimation) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:btn];
    
}

- (void)starAnimation {
    ShowViewController *vc = [[ShowViewController alloc] init]
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
