//
//  AWPolygonView.h
//  AWPolygonView
//
//  Created by AlanWang on 17/3/21.
//  Copyright © 2017年 AlanWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AWPolygonView : UIView

@property (nonatomic, strong) NSArray               *values;
@property (nonatomic, strong) UIColor               *lineColor;
@property (nonatomic, strong) UIColor               *valueLineColor;
@property (nonatomic, assign) CGFloat               radius;
@property (nonatomic, assign) NSInteger             valueRankNum;
@end
