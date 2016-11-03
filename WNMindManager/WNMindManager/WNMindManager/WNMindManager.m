//
//  WNMindManager.m
//  WNMindManager
//
//  Created by ningwu on 2016/10/9.
//  Copyright © 2016年 alen. All rights reserved.
//

#import "WNMindManager.h"
#import "UIView+Frame.h"
#import "UIBezierPath+WNPoints.h"
#import "WNMenu.h"

const static CGFloat OffSetX = 60.0;
const static CGFloat OffSetY = 35.0;

@interface WNMindManager()<WNMenuDelegate ,UIScrollViewDelegate>

@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)NSMutableArray *layersArray;
@property (nonatomic, assign)CGPoint originalPoint;//所有坐标都会依赖 原点 定位 在拉伸放缩的时候 改变原点可以重新定位
@property (nonatomic ,assign)CGPoint topItemCenter;//计算坐标假设最顶端的点坐标为已知
@property (nonatomic ,assign)CGPoint OffSetPoint;
@end

@implementation WNMindManager

- (instancetype)initWithPreView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.layersArray = [NSMutableArray array];
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.width * 5, view.height * 5)];
        [view addSubview:_contentView];
        _contentView.backgroundColor = [UIColor redColor];
        _contentView.center = CGPointMake(_contentView.center.x, view.height / 2.0);
        self.originalPoint = CGPointMake(40, _contentView.height / 2.0);
        _topItemCenter = CGPointMake(1, 1);
        [self addGestureRecognizerToView:_contentView];
    }
    return self;
}

#pragma mark -- 添加手势
- (void) addGestureRecognizerToView:(UIView *)view
{
    [view setUserInteractionEnabled:YES];
    [view setMultipleTouchEnabled:YES];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (void)setDataSource:(WNPointModel *)dataSource
{
    _dataSource = dataSource;
}

- (void)reloadData
{
    for (WNMenu *menu in self.contentView.subviews) {
        if ([menu isKindOfClass:[WNMenu class]]) {
            [menu removeFromSuperview];
        }
    }
    if (self.dataSource == nil) {
        return;
    }
    //给所有的item通过算法给出合适的 center
    [self setSubItemCenter:self.dataSource];
    [self drawMap:self.dataSource];
    [self setMenu:self.dataSource];
}
/*
 @property (nonatomic, assign)CGPoint center;坐标值
 @property (nonatomic, assign)CGPoint leftPoint;
 @property (nonatomic, assign)CGPoint rightPoint;
 @property (nonatomic, strong)UIBezierPath *path;
 @property (nonatomic, strong)CALayer *layer;
 @property (nonatomic, assign)NSInteger level;
 @property (nonatomic, assign)NSInteger offSetX;根据title的长度定
*/
- (void)clearDataSource:(WNPointModel *)model
{
    model.center = CGPointZero;
    model.leftPoint = CGPointZero;
    model.rightPoint = CGPointZero;
    model.path = nil;
    [model.layer removeFromSuperlayer];
    model.layer = nil;
    model.level = 0;
    model.offSetX = 0;
    for (WNPointModel *subModel in model.subPoints) {
        [self clearDataSource:subModel];
    }
}

- (void)setMenu:(WNPointModel *)model
{
    if (model.subPoints.count > 0) {
        for (int i = 0; i < model.subPoints.count; i++) {
            WNPointModel *subModel = [model.subPoints objectAtIndex:i];
            WNMenu *menu = [[WNMenu alloc]initWithTitles:@[@"增",@"删",@"改",@"+",@"-",] model:subModel];
            menu.delegate = self;
            [self.contentView addSubview:menu];
            menu.center = CGPointMake(subModel.leftPoint.x + subModel.offSetX / 2.0, subModel.center.y);
            
            [self setMenu:subModel];
        }
    }
}

- (void)selectedWNMenuItem:(NSInteger)index model:(WNPointModel *)model
{
    if ([self.delegate respondsToSelector:@selector(didSubItemAtIndex:model:mindManager:)]) {
        [self.delegate didSubItemAtIndex:index model:model mindManager:self];
    }
}

- (void)drawMap:(WNPointModel *)model
{
    if (model.subPoints.count > 0) {
        for (int i = 0; i < model.subPoints.count; i++) {
            WNPointModel *subModel = [model.subPoints objectAtIndex:i];
            [self drawBeaierPath:model.rightPoint subModel:subModel];
            [self drawMap:subModel];
        }
    }
}

//根据起始点 重点绘制 图形
- (void)drawBeaierPath:(CGPoint)originPoint subModel:(WNPointModel *)subModel
{
    UIBezierPath *curve = [UIBezierPath bezierPath];
    [curve moveToPoint:originPoint];
    [curve addBezierPath:originPoint endPoint:subModel.leftPoint];
    subModel.path = curve;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    _shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    _shapeLayer.fillColor = nil;
    _shapeLayer.lineWidth = 1;
    _shapeLayer.path = curve.CGPath;
    _shapeLayer.lineCap = kCALineCapRound;
    [self.contentView.layer addSublayer:_shapeLayer];
    [self.layersArray addObject:_shapeLayer];
    subModel.layer = _shapeLayer;
}

//回溯遍历所有的坐标值
- (void)setSubItemCenter:(WNPointModel *)model
{
    WNPointModel *topModel = [self getTopPoint:model];
    topModel.center = _topItemCenter;
    
    [self setLevel:self.dataSource];
    [self setLastItemValueY:self.dataSource];
    [self setAllItemValueY:self.dataSource];
    _OffSetPoint = CGPointMake(_originalPoint.x - self.dataSource.center.x, _originalPoint.y - self.dataSource.center.y);
    [self moveAllPointAtOffSetPoint:_OffSetPoint model:self.dataSource];
}

//平行移动所有的点 到合适的位置
- (void)moveAllPointAtOffSetPoint:(CGPoint)offSetPoint model:(WNPointModel *)model
{
    model.center = CGPointMake(model.center.x + offSetPoint.x, model.center.y + offSetPoint.y);
    model.leftPoint = CGPointMake(model.leftPoint.x + offSetPoint.x, model.center.y);
    model.rightPoint = CGPointMake(model.rightPoint.x + offSetPoint.x, model.center.y);
    if (model.subPoints.count > 0) {
        for (WNPointModel *subModel in model.subPoints) {
            [self moveAllPointAtOffSetPoint:_OffSetPoint model:subModel];
        }
    }else{
        
    }
}

//给没个树最后一个附Y值 （没有子节点的节点）
WNPointModel *preModel;
- (void)setLastItemValueY:(WNPointModel *)model
{
    if (model.subPoints.count > 0) {
        for (int i = 0; i < model.subPoints.count; i++) {
            WNPointModel *subModel = [model.subPoints objectAtIndex:i];
            [self setLastItemValueY:subModel];
        }
    }else{
        model.center = CGPointMake(model.level * OffSetX, preModel.center.y + OffSetY);
        model.leftPoint = CGPointMake(model.leftPoint.x, preModel.center.y + OffSetY);
        model.rightPoint = CGPointMake(model.rightPoint.x, preModel.center.y + OffSetY);
        preModel = model;
    }
}

NSInteger level = 0;
- (void)setLevel:(WNPointModel *)model
{
    WNMenu *menu = [[WNMenu alloc]init];
    if (model.subPoints.count > 0) {
        for (int i = 0; i < model.subPoints.count; i++) {
            WNPointModel *subModel = [model.subPoints objectAtIndex:i];
            subModel.level = model.level + 1;
            subModel.offSetX = [menu getWidthTitle:model.title];
            subModel.leftPoint = CGPointMake(model.rightPoint.x + OffSetX, 0);
            subModel.rightPoint = CGPointMake(model.rightPoint.x + OffSetX + subModel.offSetX, 0);
            [self setLevel:subModel];
        }
    }else{
        
    }
}

//给没个树所有节点附Y值 （根据其最后子节点倒推赋值）
- (void)setAllItemValueY:(WNPointModel *)model
{
    if (model.center.y == 0) {
        for (int i = 0; i < model.subPoints.count; i++) {
            WNPointModel *subModel = [model.subPoints objectAtIndex:i];
            WNPointModel *firstM = [model.subPoints firstObject];
            WNPointModel *lastM = [model.subPoints lastObject];
            if (subModel.center.y > 0 && firstM.center.y > 0 && lastM.center.y > 0) {
                model.center = SetSuperItemCenter(model);
                model.leftPoint = CGPointMake(model.leftPoint.x, model.center.y);
                model.rightPoint = CGPointMake(model.rightPoint.x, model.center.y);
                [self setAllItemValueY:self.dataSource];
            }else{
                [self setAllItemValueY:subModel];
            }
        }
    }
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

CGPoint SetSuperItemCenter(WNPointModel *model)
{
    WNPointModel *firstModel = [model.subPoints firstObject];
    WNPointModel *lastModel = [model.subPoints lastObject];
    return CGPointMake(model.level * OffSetX, firstModel.center.y + (lastModel.center.y - firstModel.center.y)/2.0);
}

- (void)findSuperModel:(WNPointModel*)model inModel:(WNPointModel *)limitModel
{
    if (limitModel.subPoints.count == 0) {
        
    }else{
        for (WNPointModel *subModel in limitModel.subPoints) {
            if (CGPointEqualToPoint(subModel.center, model.center)) {
                superModel = limitModel;
//                return limitModel;
            }else{
                [self findSuperModel:model inModel:subModel];
            }
        }
    }
}


- (void)addSubItem:(WNPointModel *)model
{
    
    WNPointModel *submodel = [[WNPointModel alloc]init];
    submodel.title = @"addItem";
    NSMutableArray *muarray = [NSMutableArray arrayWithArray:model.subPoints];
    [muarray addObject:submodel];
    [self clearDataSource:self.dataSource];
    model.subPoints = muarray;
    [self reloadData];
}
WNPointModel *superModel;
- (void)deleteItem:(WNPointModel *)model
{
    [self findSuperModel:model inModel:self.dataSource];
    if (superModel) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:superModel.subPoints];
        [array removeObject:model];
        [self clearDataSource:self.dataSource];
        superModel.subPoints = array;
        [self reloadData];
        superModel = nil;
    }else{
        
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}
@end
