//
//  ShowViewController.m
//  AWPolygonView
//
//  Created by alanwang on 17/5/22.
//  Copyright © 2017年 AlanWang. All rights reserved.
//

#import "ShowViewController.h"
#import "AWPolygonView.h"


@interface ShowViewController ()
@property (nonatomic, strong) AWPolygonView *polygonView;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _polygonView = [[AWPolygonView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    _polygonView.values = @[@(0.3),@(0.7),@(0.4),@(0.6),@(0.7),@(0.4)];
    [self.view addSubview:_polygonView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
