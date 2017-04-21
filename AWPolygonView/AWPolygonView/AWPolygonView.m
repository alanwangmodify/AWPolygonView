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
{
    CGFloat _centerX;
    CGFloat _centerY;
}
@property (nonatomic, assign) NSInteger                                     sideNum;
@property (nonatomic, strong) NSArray<NSArray<NSValue *> *>                 *cornerPointArrs;
@property (nonatomic, strong) NSArray<NSValue *>                            *valuePoints;

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
    _centerX = self.bounds.size.width/2;
    _centerY = self.bounds.size.height/2;
    if (self.radius == 0) {
        self.radius = self.bounds.size.width/2;
    }
    if (!self.lineColor) {
        self.lineColor = [UIColor yellowColor];
    }
    
    if (!self.valueLineColor) {
        self.valueLineColor = [UIColor colorWithRed:255.0/23.0 green:10.0 blue:10.0 alpha:0.6];
    }
    
    if (!self.valueRankNum) {
        self.valueRankNum = 3;
    }
    
}

- (void)makePoints {
    
    
    NSMutableArray *tempValuePoints = [NSMutableArray new];
    NSMutableArray *tempCornerPointArrs = [NSMutableArray new];
    
    
    //Values
    for (int i = 0; i < self.sideNum; i++) {
        if (self.values.count > i) {
            CGFloat valueRadius = [self.values[i] floatValue] * self.radius;
            CGPoint valuePoint =  CGPointMake(_centerX - ANGLE_COS(90.0 - 360.0 /self.sideNum * i) * valueRadius, _centerY - ANGLE_SIN(90.0 - 360.0 /self.sideNum * i) * valueRadius);
            [tempValuePoints addObject:[NSValue valueWithCGPoint:valuePoint]];
        }
    }
    
    // Side corners
    CGFloat rankValue = self.radius/self.valueRankNum;
    for (int j = 0; j < self.valueRankNum; j++) {
        NSMutableArray *tempCornerPoints = [NSMutableArray new];
        for (int i = 0; i < self.sideNum; i++) {
            NSInteger rank = j+1;
            CGPoint cornerPoint = CGPointMake(_centerX - ANGLE_COS(90.0 - 360.0 /self.sideNum * i) * rankValue * rank, _centerY - ANGLE_SIN(90.0 - 360.0 /self.sideNum * i) * rankValue * rank);
            [tempCornerPoints addObject:[NSValue valueWithCGPoint:cornerPoint]];
        }
        [tempCornerPointArrs addObject:[tempCornerPoints copy]];
    }
    
    
    
    self.cornerPointArrs = [tempCornerPointArrs copy];
    self.valuePoints = [tempValuePoints copy];
    
}


- (NSArray *)getPointsWithRadius:(CGFloat )radius {
    

    NSMutableArray *inCornerPoints = [NSMutableArray new];

    for (int i = 0; i < self.sideNum; i++) {
        
        CGPoint cornerPoint = CGPointMake(_centerX - ANGLE_COS(90.0 - 360.0 /self.sideNum * i) * self.radius, _centerY - ANGLE_SIN(90.0 - 360.0 /self.sideNum * i) * self.radius);
        
        [inCornerPoints addObject:[NSValue valueWithCGPoint:cornerPoint]];
    }
    return [inCornerPoints copy];
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
    [self drawLineFromCenterWithContext:context];
    [self drawValueSideWithContext:context];

}


- (void)drawSideWithContext:(CGContextRef )context {
    for (NSArray *ponis in self.cornerPointArrs) {
        [self drawLineWithContext:context points:ponis color:self.lineColor];
    }
}


- (void)drawLineFromCenterWithContext:(CGContextRef )context {
    

    NSArray *poins = [self.cornerPointArrs lastObject];
    
    
    for (int i = 0; i < poins.count; i++) {
        
        CGContextMoveToPoint(context, _centerX, _centerY);
        CGPoint point = [poins[i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextSetLineWidth(context, 1);
    }
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextStrokePath(context);
    
}


- (void)drawLineWithContext:(CGContextRef )context points:(NSArray<NSValue *> *)points color:(UIColor *)color{
    if (points.count == 0) {
        return;
    }
    CGPoint firstPoint = [points[0] CGPointValue];
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    
    for (int i = 1; i < points.count; i++) {
        
        CGPoint point = [points[i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextSetLineWidth(context, 1);
    }
    
    CGContextAddLineToPoint(context, firstPoint.x, firstPoint.y);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokePath(context);
    
}


- (void)drawValueSideWithContext:(CGContextRef )context {
    
    if (self.valuePoints.count == 0) {
        return;
    }
    CGPoint firstPoint = [[self.valuePoints firstObject] CGPointValue];
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    for (int i = 1; i < self.valuePoints.count; i++) {
        
        CGPoint point = [self.valuePoints[i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextSetLineWidth(context, 1);
    }
    CGContextAddLineToPoint(context, firstPoint.x, firstPoint.y);
    CGContextSetFillColorWithColor(context, self.valueLineColor.CGColor);
    CGContextFillPath(context);
    
}


#pragma mark - Animation


@end
