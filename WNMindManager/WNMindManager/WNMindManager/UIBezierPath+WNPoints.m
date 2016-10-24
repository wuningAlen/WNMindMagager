//
//  UIBezierPath+WNPoints.m
//  WNMindManager
//
//  Created by ningwu on 2016/10/9.
//  Copyright © 2016年 alen. All rights reserved.
//

#import "UIBezierPath+WNPoints.h"

static const CGFloat xFactor = 0.6;
static const CGFloat yFactor = -0.02;

@implementation UIBezierPath (WNPoints)

- (void)addBezierPath:(CGPoint)originalPoint endPoint:(CGPoint)endPoint
{
    CGPoint pointControl1 = FirstControlPoint(originalPoint, endPoint);
    CGPoint pointControl2 = SencondCondtrolPoint(originalPoint, endPoint);
    [self moveToPoint:originalPoint];
    [self addCurveToPoint:endPoint controlPoint1:pointControl1 controlPoint2:pointControl2];
}

CGPoint FirstControlPoint(CGPoint originalPoint,CGPoint endPoint)
{
    return CGPointMake(originalPoint.x + (endPoint.x - originalPoint.x)*xFactor, originalPoint.y + (endPoint.y - originalPoint.y)*yFactor);
}

CGPoint SencondCondtrolPoint(CGPoint originalPoint, CGPoint endPoint)
{
    return CGPointMake(endPoint.x - (endPoint.x - originalPoint.x) * xFactor,endPoint.y - (endPoint.y - originalPoint.y)*yFactor);
}
@end
