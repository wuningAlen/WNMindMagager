//
//  WNLabelView.m
//  WNMindManager
//
//  Created by wuning on 16/6/15.
//  Copyright © 2016年 alen. All rights reserved.
//

#import "WNLabelView.h"
#import "UIView+Frame.h"

@implementation WNLabelView
{
    NSMutableDictionary *_coordinateDictionary;
}
+ (instancetype)instancet
{
    WNLabelView *view = [[WNLabelView alloc]init];
    view.backgroundColor = [UIColor redColor];
    
    return view;
}

- (void)setText:(NSString *)text
{
    _coordinateDictionary = [NSMutableDictionary dictionary];
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    [label sizeToFit];
    label.width = label.width + 10;
    label.height = label.height + 10;
    self.width = label.width + 100;
    self.height = label.height + 50;
    [self addSubview:label];
    label.originX = 50;
    label.originY = 50;
    label.layer.cornerRadius = label.width/2.0;
    label.layer.masksToBounds = YES;
    
    UIButton *mainBtn = [[UIButton alloc]initWithFrame:label.frame];
    [mainBtn addTarget:self action:@selector(explode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mainBtn];
    
    NSArray *titles = @[@"增",@"删",@"改"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [self insertSubview:button belowSubview:mainBtn];
        button.center = mainBtn.center;
        button.tag = i;
        [button addTarget:self action:@selector(onSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)explode{
    
}

- (void)onSelectedItem:(UIButton *)btn
{
    
}
@end
