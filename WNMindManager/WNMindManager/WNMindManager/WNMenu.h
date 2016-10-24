//
//  WNMenu.h
//  WNMindManager
//
//  Created by ningwu on 2016/10/18.
//  Copyright © 2016年 alen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNPointModel.h"

@protocol WNMenuDelegate <NSObject>

- (void)selectedWNMenuItem:(NSInteger)index model:(WNPointModel *)model;

@end

@interface WNMenu : UIView

@property (nonatomic, strong, readonly)NSArray *items;
@property (nonatomic, assign ,readonly)CGFloat menuWidth;
@property (nonatomic, strong, readonly)WNPointModel *model;
@property (nonatomic, assign)id<WNMenuDelegate>delegate;

- (instancetype)initWithTitles:(NSArray *)titles model:(WNPointModel *)model;

- (CGFloat)getWidthTitle:(NSString *)title;

@end
