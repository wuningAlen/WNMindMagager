//
//  UIBezierPath+WNPoints.h
//  WNMindManager
//
//  Created by ningwu on 2016/10/9.
//  Copyright © 2016年 alen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (WNPoints)

- (void)addBezierPath:(CGPoint)originalPoint endPoint:(CGPoint)endPoint;

@end
