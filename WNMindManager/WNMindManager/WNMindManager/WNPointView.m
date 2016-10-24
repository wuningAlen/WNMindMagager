//
//  WNPointView.m
//  WNMindManager
//
//  Created by wuning on 16/6/13.
//  Copyright © 2016年 alen. All rights reserved.
//

#import "WNPointView.h"

@implementation WNPointView

+ (instancetype)pointView
{
    WNPointView *pointView = [[self alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    pointView.backgroundColor = [UIColor magentaColor];
    [pointView addTarget:pointView action:@selector(touchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    return pointView;
}

- (void)touchDragInside:(WNPointView *)pointView withEvent:(UIEvent *)event
{
    pointView.center = [[[event allTouches]anyObject] locationInView:self.superview];
    if (self.callBack) {
        self.callBack(self);
    }
}

@end
