//
//  WNMindManager.h
//  WNMindManager
//
//  Created by ningwu on 2016/10/9.
//  Copyright © 2016年 alen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WNPointModel.h"
#import <UIKit/UIKit.h>

@class WNMindManager;
@protocol MindManagerDelegate <NSObject>

@optional
- (void)didExpandItem:(WNPointModel *)model mindManager:(WNMindManager *)manager;
- (void)didSnapItem:(WNMindManager *)model mindManager:(WNMindManager *)manager;
- (void)didSubItemAtIndex:(NSInteger)index model:(WNPointModel *)model mindManager:(WNMindManager *)manager;

@end

@interface WNMindManager : NSObject

@property (nonatomic, strong ,readonly)UIScrollView *stretchView; //无限延伸的容器
@property (nonatomic, strong)WNPointModel *dataSource; //数据源
@property (nonatomic, assign)id<MindManagerDelegate>delegate;

- (instancetype)initWithPreView:(UIView *)view;

- (void)reloadData;

- (void)addSubItem:(WNPointModel *)model;

- (void)deleteItem:(WNPointModel *)model;
@end
