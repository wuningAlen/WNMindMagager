//
//  WNMenu.m
//  WNMindManager
//
//  Created by ningwu on 2016/10/18.
//  Copyright © 2016年 alen. All rights reserved.
//

#import "WNMenu.h"

static const int kItemInitTag = 1001;
static const CGFloat kAngleOffset = M_PI_2 / 2;
static const CGFloat kSphereLength = 40;
static const float kSphereDamping = 1;
static const float MenuHeight = 24.0f;

@interface WNMenu()
{
    
}
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;

@property (strong, nonatomic) NSMutableArray *itemViews;
@property (strong, nonatomic) NSMutableArray *positions;
@property (strong, nonatomic) UILabel *startView;

@property (assign, nonatomic) BOOL expanded;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation WNMenu

- (instancetype)initWithTitles:(NSArray *)titles model:(WNPointModel *)model
{
    self = [super initWithFrame:CGRectMake(0, 0, MenuHeight, MenuHeight)];
    if (self) {
        self.expanded = NO;
        self.itemViews = [NSMutableArray array];
        self.positions = [NSMutableArray array];
        _items = titles;
        _model = model;
        CGSize size = [self configItems:model];
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)didMoveToSuperview
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.expanded) {
        for (UIButton *btn in self.itemViews) {
            CGPoint btnP = [self convertPoint:point toView:btn];
            if ([btn pointInside:btnP withEvent:event]) {
                return btn;
            }
        }
        UIView *view = [super hitTest:point withEvent:event];
        return view;
    }else{
        UIView *view = [super hitTest:point withEvent:event];
        return view;
    }
}

//初始化
- (CGSize)configItems:(WNPointModel *)model
{
    self.startView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MenuHeight, MenuHeight)];
    self.startView.userInteractionEnabled = YES;
    self.startView.font = [UIFont systemFontOfSize:12];
    self.startView.textColor = [UIColor darkGrayColor];
    self.startView.center = [self getSelfCenter];
    self.startView.text = model.title;
    [self.startView sizeToFit];
    self.startView.layer.cornerRadius = 4;
    self.startView.layer.masksToBounds = YES;
    self.startView.layer.borderWidth = 1;
    self.startView.layer.borderColor = [UIColor grayColor].CGColor;
    self.startView.backgroundColor = [UIColor whiteColor];
    self.startView.textAlignment = NSTextAlignmentCenter;
    self.startView.frame = CGRectMake(0, 0, MAX(self.startView.frame.size.width + 5, MenuHeight), MenuHeight);
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTap:)];
    
    [self.startView addGestureRecognizer:gr];
    for (int i = 0; i < _items.count; i++) {
        NSString *text = [_items objectAtIndex:i];
        UIButton *btn = [self getItem:text index:i];
        [self addSubview:btn];
        [self.itemViews addObject:btn];
        CGPoint position = [self centerForSphereAtIndex:i];
        btn.center = [self getSelfCenter];
        [self.positions addObject:[NSValue valueWithCGPoint:position]];
    }
    [self addSubview:self.startView];
    return self.startView.frame.size;
}

- (CGFloat)getWidthTitle:(NSString *)title
{
    if (self.startView) {
        return MAX(self.startView.frame.size.width, MenuHeight);
    }else{
        self.startView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MenuHeight, MenuHeight)];
        self.startView.userInteractionEnabled = YES;
        self.startView.backgroundColor = [UIColor redColor];
        self.startView.font = [UIFont systemFontOfSize:12];
        self.startView.textColor = [UIColor darkGrayColor];
        self.startView.center = [self getSelfCenter];
        self.startView.text = title;
        [self.startView sizeThatFits:CGSizeMake(MAXFLOAT, MenuHeight)];
        return MAX(self.startView.frame.size.width + 5, MenuHeight);
    }
}

- (void)startTap:(UITapGestureRecognizer *)gr
{
    [self.animator removeAllBehaviors];
    if (self.expanded) {
        for (int i = 0; i < self.itemViews.count; i++) {
            [self snapToOrginalWithIndex:i];
        }
    }else{
        for (int i = 0; i < self.itemViews.count; i++) {
            [self snapToStartWithIndex:i];
        }
    }
    self.expanded = !self.expanded;
}

- (void)snapToStartWithIndex:(NSInteger)index
{
    id positionValue = self.positions[index];
    CGPoint position = [positionValue CGPointValue];
    UISnapBehavior *sanp = [[UISnapBehavior alloc]initWithItem:[self.itemViews objectAtIndex:index] snapToPoint:position];
    sanp.damping = kSphereDamping;
    [self.animator addBehavior:sanp];
}

- (void)snapToOrginalWithIndex:(NSInteger)index
{
    CGPoint position = [self getSelfCenter];
    UISnapBehavior *sanp = [[UISnapBehavior alloc]initWithItem:[self.itemViews objectAtIndex:index] snapToPoint:position];
    sanp.damping = 1;
    [self.animator addBehavior:sanp];
}

- (UIButton *)getItem:(NSString *)text index:(NSInteger)index
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MenuHeight, MenuHeight)];
    button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    button.tag = index + kItemInitTag;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateSelected];
    [button addTarget:self action:@selector(panned:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = button.frame.size.width / 2.0;
    button.layer.masksToBounds = YES;
    return button;
}

- (void)panned:(UIButton *)btn
{
    self.expanded = NO;
    [self.animator removeAllBehaviors];
    if ([self.delegate respondsToSelector:@selector(selectedWNMenuItem: model:)]) {
        [self.delegate selectedWNMenuItem:btn.tag - kItemInitTag model:self.model];
    }
    for (int i = 0; i < self.itemViews.count; i++) {
        [self snapToOrginalWithIndex:i];
    }
}

- (CGPoint)centerForSphereAtIndex:(int)index
{
    if (_items.count%2==1) {
        NSInteger count = _items.count/2;
        
        CGFloat firstAngle = M_PI + (M_PI_2 - kAngleOffset*count) + index * kAngleOffset;
        CGPoint startPoint = [self getSelfCenter];
        CGFloat x = startPoint.x + cos(firstAngle) * kSphereLength;
        CGFloat y = startPoint.y + sin(firstAngle) * kSphereLength;
        CGPoint position = CGPointMake(x, y);
        return position;
    }else{
        CGFloat count = _items.count/2.0;
        count = count - 0.5;
        CGFloat firstAngle = M_PI + (M_PI_2 - kAngleOffset*count) + index * kAngleOffset;
        CGPoint startPoint = [self getSelfCenter];
        CGFloat x = startPoint.x + cos(firstAngle) * kSphereLength;
        CGFloat y = startPoint.y + sin(firstAngle) * kSphereLength;
        CGPoint position = CGPointMake(x, y);
        return position;
    }
    
}

- (CGPoint)getSelfCenter
{
    CGFloat x = self.startView.frame.size.width / 2.0;
    CGFloat y = self.startView.frame.size.height / 2.0;
    return CGPointMake(x, y);
}

@end
