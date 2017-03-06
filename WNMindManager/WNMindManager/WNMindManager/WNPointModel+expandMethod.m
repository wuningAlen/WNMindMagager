//
//  WNPointModel+expandMethod.m
//  WNMindManager
//
//  Created by ningwu on 2016/11/3.
//  Copyright © 2016年 alen. All rights reserved.
//

#import "WNPointModel+expandMethod.h"

@implementation WNPointModel (expandMethod)

- (void)addPropertyWithCenterPoint:(CGPoint *)centerPoint model:(WNPointModel *)model
{
    
}

//获取最上面的 item
- (WNPointModel *)getTopPoint:(WNPointModel *)model
{
    if (model.subPoints.count > 0) {
        [self getTopPoint:[model.subPoints firstObject]];
        return nil;
    }else{
        return model;
    }
}
@end
