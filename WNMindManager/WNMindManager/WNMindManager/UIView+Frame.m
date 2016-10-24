//
//  UIView+Frame.m
//  writer
//
//  Created by Sophia on 15/5/18.
//  Copyright (c) 2015年 writer. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius{
   CGContextRef context = UIGraphicsGetCurrentContext();
   
   
   CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
   
   CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
   CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
   CGContextMoveToPoint(context, minx, midy);
   CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
   CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
   CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
   CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
   CGContextClosePath(context);
   CGContextDrawPath(context, kCGPathFill);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect newFrame = self.frame;
    newFrame.size.height = width;
    self.frame = newFrame;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)x
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)y
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}

@end
