//
//  WNPointView.h
//  WNMindManager
//
//  Created by wuning on 16/6/13.
//  Copyright © 2016年 alen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WNPointView : UIControl

+ (instancetype)pointView;

@property (nonatomic, copy)void(^callBack)(WNPointView *view);

@end
