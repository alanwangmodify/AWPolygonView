//
//  ViewController.m
//  AWPolygonView
//
//  Created by AlanWang on 17/3/21.
//  Copyright © 2017年 AlanWang. All rights reserved.
//

#import "ViewController.h"
#import "AWPolygonView.h"

@interface ViewController ()

@property (nonatomic, strong) AWPolygonView *polygonView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _polygonView = [[AWPolygonView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    _polygonView.values = @[@(0.3),@(0.7),@(0.4),@(0.6),@(0.7),@(0.4)];
    [self.view addSubview:_polygonView];
    

    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(100, 400, 50, 50);
    [btn addTarget:self action:@selector(starAnimation) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:btn];
    
}

- (void)starAnimation {
    [_polygonView addStrokeEndAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
