//
//  UIView+Frame.h
//  writer
//
//  Created by Sophia on 15/5/18.
//  Copyright (c) 2015年 writer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)originX;
- (void)setOriginX:(CGFloat)x;

- (CGFloat)originY;
- (void)setOriginY:(CGFloat)y;
+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius;
@end
