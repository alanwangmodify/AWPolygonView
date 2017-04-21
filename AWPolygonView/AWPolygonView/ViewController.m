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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    AWPolygonView *view = [[AWPolygonView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view.values = @[@(0.3),@(0.7),@(0.4),@(0.6),@(0.7),@(0.4)];
    [self.view addSubview:view];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
