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
    BOOL    _toDraw;
}
@property (nonatomic, assign) NSInteger                                     sideNum;
@property (nonatomic, strong) NSArray<NSArray<NSValue *> *>                 *cornerPointArrs;
@property (nonatomic, strong) NSArray<NSValue *>                            *valuePoints;

@property (nonatomic, strong) CAShapeLayer                                  *valueLayer;
@property (nonatomic, strong) CAShapeLayer                                  *shapeLayer;

@property (nonatomic, strong) UIBezierPath                                  *bezierPath;
@property (nonatomic, strong) UIBezierPath                                  *valuePath;


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

#pragma mark - Overwrite
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.layer addSublayer:self.shapeLayer];
    [self.layer addSublayer:self.valueLayer];
    [self drawLineFromCenter];
    [self drawValueSide];
    [self drawSide];
    self.shapeLayer.path = self.bezierPath.CGPath;
    [self addStrokeEndAnimationToLayer:self.shapeLayer];

}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.shapeLayer.frame = self.bounds;
    self.valueLayer.frame = self.bounds;
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
    if (!self.animationDuration) {
        self.animationDuration = 1.35;
    }
}


- (void)makePoints {
    
    
    NSMutableArray *tempValuePoints = [NSMutableArray new];
    NSMutableArray *tempCornerPointArrs = [NSMutableArray new];
    
    //Values
    for (int i = 0; i < self.sideNum; i++) {
        if (self.values.count > i) {
            CGFloat valueRadius = [self.values[i] floatValue] * self.radius;
            CGPoint valuePoint =  CGPointMake(_centerX - ANGLE_COS(90.0 - 360.0 /self.sideNum * i) * valueRadius,
                                              _centerY - ANGLE_SIN(90.0 - 360.0 /self.sideNum * i) * valueRadius);
            [tempValuePoints addObject:[NSValue valueWithCGPoint:valuePoint]];
        }
    }
    
    // Side corners
    CGFloat rankValue = self.radius/self.valueRankNum;
    for (int j = 0; j < self.valueRankNum; j++) {
        NSMutableArray *tempCornerPoints = [NSMutableArray new];
        for (int i = 0; i < self.sideNum; i++) {
            NSInteger rank = j+1;
            CGPoint cornerPoint = CGPointMake(_centerX - ANGLE_COS(90.0 - 360.0 /self.sideNum * i) * rankValue * rank,
                                              _centerY - ANGLE_SIN(90.0 - 360.0 /self.sideNum * i) * rankValue * rank);
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
        
        CGPoint cornerPoint = CGPointMake(_centerX - ANGLE_COS(90.0 - 360.0 /self.sideNum * i) * self.radius,
                                          _centerY - ANGLE_SIN(90.0 - 360.0 /self.sideNum * i) * self.radius);
        
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
- (void)drawSide {
    for (NSArray *points in self.cornerPointArrs) {
        [self drawLineWithPoints:points color:self.lineColor];
    }
}


- (void)drawLineWithPoints:(NSArray<NSValue *> *)points color:(UIColor *)color{
    if (points.count == 0) {
        return;
    }
    CGPoint firstPoint = [points[0] CGPointValue];
    
    [_bezierPath moveToPoint:firstPoint];
    for (int i = 1; i < points.count; i++) {
        
        CGPoint point = [points[i] CGPointValue];
        [_bezierPath addLineToPoint:point];
        _bezierPath.lineWidth = 1;
    }
    [_bezierPath addLineToPoint:firstPoint];
    
}


- (void)drawLineFromCenter {
    
    NSArray *poins = [self.cornerPointArrs lastObject];
    
    for (int i = 0; i < poins.count; i++) {
        [self.bezierPath moveToPoint:CGPointMake(_centerX, _centerY)];
        CGPoint point = [poins[i] CGPointValue];
        [self.bezierPath addLineToPoint:point];
        [self.bezierPath setLineWidth:1];
    }
    self.shapeLayer.strokeColor = self.lineColor.CGColor;

}


- (void)drawValueSide{
    
    if (self.valuePoints.count == 0) {
        return;
    }
    CGPoint firstPoint = [[self.valuePoints firstObject] CGPointValue];
    
    [self.valuePath moveToPoint:firstPoint];
    for (int i = 1; i < self.valuePoints.count; i++) {
        
        CGPoint point = [self.valuePoints[i] CGPointValue];
        [self.valuePath addLineToPoint:point];
        self.valuePath.lineWidth = 1;
    }
    [self.valuePath addLineToPoint:firstPoint];
    self.valueLayer.fillColor = self.valueLineColor.CGColor;
    self.valueLayer.strokeColor = self.valueLineColor.CGColor;
    self.valueLayer.path = self.valuePath.CGPath;
    
}
#pragma mark - Action 
- (void)show {
    
    _toDraw = YES;
    [self setNeedsDisplay];

}
#pragma makr - Getter MEthod 
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

- (CAShapeLayer *)valueLayer {
    if (!_valueLayer) {
        _valueLayer = [CAShapeLayer layer];
    }
    return _valueLayer;
}

- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
    }
    return _bezierPath;
}
- (UIBezierPath *)valuePath {
    if (!_valuePath) {
        _valuePath = [UIBezierPath bezierPath];
    }
    return _bezierPath;
}

#pragma mark - Animation
- (void)addStrokeEndAnimationToLayer:(CAShapeLayer *)layer {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = self.animationDuration;
    [layer addAnimation:animation forKey:@"stokeEndAnimation"];
}

@end
