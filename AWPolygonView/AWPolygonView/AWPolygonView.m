//
//  AWPolygonView.m
//  AWPolygonView
//
//  Created by AlanWang on 17/3/21.
//  Copyright © 2017年 AlanWang. All rights reserved.
//

#import "AWPolygonView.h"


#define ANGLE_COS(Angle) cos(M_PI / 180 * (Angle))
#define ANGLE_SIN(Angle) sin(M_PI / 180 * (Angle))


@interface AWPolygonView ()

@property (nonatomic, assign) CGFloat               radius;
@property (nonatomic, assign) NSInteger             sideNum;
@property (nonatomic, strong) NSArray               *cornerPoints;
@property (nonatomic, strong) NSArray               *valuePoints;

@end

@implementation AWPolygonView


- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}

#pragma mark - data
- (void)prepaeData {
    self.sideNum = self.values.count;
    if (self.radius == 0) {
        self.radius = self.bounds.size.width;
    }
}

- (void)makePoints {
    
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2;
    
    NSMutableArray *tempCornerPoints = [NSMutableArray new];
    NSMutableArray *tempValuePoints = [NSMutableArray new];
    
    for (int i = 0; i < self.sideNum; i++) {
        
        CGPoint cornerPoint = CGPointMake(centerX - ANGLE_COS(90.0 - 360.0 * i) * self.radius, centerY - ANGLE_SIN(90.0 - 360.0 * i) * self.radius);
        
        [tempCornerPoints addObject:[NSValue valueWithCGPoint:cornerPoint]];
        
        if (self.values.count > i) {
            CGFloat valueRadius = [self.values[i] floatValue] * self.radius;
            CGPoint valuePoint =  CGPointMake(centerX - ANGLE_COS(90.0 - 360.0 * i) * valueRadius, centerY - ANGLE_SIN(90.0 - 360.0 * i) * valueRadius);
            [tempValuePoints addObject:[NSValue valueWithCGPoint:valuePoint]];
        }
    }
    
    self.cornerPoints = [tempCornerPoints copy];
    self.valuePoints = [tempValuePoints copy];
    
}
- (void)setValues:(NSArray *)values {
    _values = values;
    [self prepaeData];
    [self makePoints];

}
#pragma mark - draw
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
  
    [self drawSideWithContext:context];
}

- (void)drawSideWithContext:(CGContextRef )context {
    
    if (self.cornerPoints.count == 0) {
        return;
    }
    CGPoint firstPoint = [self.cornerPoints[0] CGPointValue];
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    for (int i = 1; i < self.cornerPoints.count; i++) {

        CGPoint point = [self.cornerPoints[i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextSetLineWidth(context, 1);
        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    }
    
}

- (void)drawLineWithContext:(CGContextRef )context {

}


#pragma mark -



@end
