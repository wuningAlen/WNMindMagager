//
//  WNPointModel.h
//  WNMindManager
//
//  Created by ningwu on 2016/10/9.
//  Copyright © 2016年 alen. All rights reserved.
//

/*
 每个节点的数据源模型
 */
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface WNPointModel : NSObject

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSArray *subPoints;

/*
 下面是自身使用的属性值 使用时可以忽略
 */
@property (nonatomic, assign)CGPoint center;//坐标值
@property (nonatomic, assign)CGPoint leftPoint;
@property (nonatomic, assign)CGPoint rightPoint;
@property (nonatomic, strong)UIBezierPath *path;
@property (nonatomic, strong)CALayer *layer;
@property (nonatomic, assign)NSInteger level;
@property (nonatomic, assign)NSInteger offSetX;//根据title的长度定

@end
