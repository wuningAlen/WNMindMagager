//
//  ViewController.m
//  WNMindManager
//
//  Created by wuning on 16/6/13.
//  Copyright © 2016年 alen. All rights reserved.
//

#import "ViewController.h"
#import "WNMindManager.h"

@interface ViewController ()<MindManagerDelegate>
{
    WNPointModel *_dataSource;
    WNMindManager *_mindManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < 3; i ++) {
//        [array addObject:[self getModel:2]];
//    }
//    WNPointModel *model = [[WNPointModel alloc]init];
//    model.subPoints = array;
//    model.title = @"yes";
//    
//    array = [NSMutableArray array];
//    for (int i = 0; i < 3; i ++) {
//        [array addObject:[self getModel:2]];
//    }
//    
//    _dataSource = [[WNPointModel alloc]init];
//    _dataSource.subPoints = @[model,model];
    
    WNPointModel *model22 = [[WNPointModel alloc]init];
    
    
    WNPointModel *model1 = [self getModel:3];
    WNPointModel *model2 = [self getModel:5];
    WNPointModel *subModel = [model2.subPoints objectAtIndex:0];
    subModel.subPoints = @[model1];
    
    WNPointModel *model3 = [self getModel:3];
    WNPointModel *model4 = [self getModel:4];
    
    _dataSource = [[WNPointModel alloc]init];
    _dataSource.subPoints = @[model22,model2,model3,model4];
    
    _mindManager = [[WNMindManager alloc]initWithPreView:self.view];
    _mindManager.dataSource = _dataSource;
    _mindManager.delegate = self;
    [_mindManager reloadData];
//    [_mindManager drawMapWith:_dataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)didSubItemAtIndex:(NSInteger)index model:(WNPointModel *)model mindManager:(WNMindManager *)manager
{
    switch (index) {
        case 0:
        {
            [_mindManager addSubItem:model];
        }
            break;
        case 1:
        {
            [_mindManager deleteItem:model];
        }
            break;
        default:
            break;
    }
}

- (WNPointModel *)getModel:(NSInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        WNPointModel *model = [[WNPointModel alloc]init];
        model.title = [NSString stringWithFormat:@"item%d",i];
        [array addObject:model];
    }
    WNPointModel *model = [[WNPointModel alloc]init];
    model.subPoints = array;
    model.title = @"main";
    return model;
}

- (IBAction)onButton:(id)sender {
    
}
@end
