//
//  GestrueLockView.m
//  BerzithDemo
//
//  Created by xxx on 2019/4/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GestrueLockView.h"
@interface GestrueLockView()
@property (nonatomic ,strong) NSMutableArray *selectButtonArray;/**<存放选中按钮数组*/
@property (nonatomic ,assign) CGPoint curP;/**<手指当前的点*/

@end

@implementation GestrueLockView
#define SPACE 38
#define COLUNS 9
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //布局九宫格按钮
    [self uisetting];
}

- (void)uisetting {
    CGFloat width = (self.frame.size.width - 4*SPACE)/3 ;
    CGFloat height = width;
    
    for (int i=0; i<COLUNS; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SPACE+(width+SPACE) *(i%3),SPACE+(width+SPACE) *(i/3) , width, height);
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}
- (CGPoint)getCurrentPoint:(UITouch *)touch {
    return [touch locationInView:self];
}

- (UIButton *)RectContain:(CGPoint)point {
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //1.要知道手指触摸的位置
    CGPoint curP = [self getCurrentPoint:[touches anyObject]];
    
    UIButton *btn = [self RectContain:curP];
    
    if (btn && !btn.selected) {
        btn.selected = YES;
        
        [self.selectButtonArray addObject:btn];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //1.要知道手指触摸的位置
    self.curP = [self getCurrentPoint:[touches anyObject]];
    
    UIButton *btn = [self RectContain:self.curP];
    
    if (btn && !btn.selected) {
        btn.selected = YES;
        
        [self.selectButtonArray addObject:btn];

    }
    //绘制路线
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *str = [NSMutableString string];
    //取消选中按钮状态
    for (UIButton *btn in self.selectButtonArray) {
        btn.selected = NO;
        [str appendFormat:@"%ld",btn.tag];
    }
    //清空路径
    [self.selectButtonArray removeAllObjects];
    [self setNeedsDisplay];
    
    //查看顺序
    if ([str isEqualToString:@"01258"]) {
        NSLog(@"success");
    }else {
        NSLog(@"fail");
    }
  
}

- (void)drawRect:(CGRect)rect {
    if (self.selectButtonArray.count >0) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        for (int i=0; i<self.selectButtonArray.count; i++) {
            UIButton *btn = self.selectButtonArray[i];
            if (i == 0) {
                //如果是第一个按钮,设置为路径的起点
                [path moveToPoint:btn.center];
            }else {
                [path addLineToPoint:btn.center];
            }
        }
        
        [path addLineToPoint:self.curP];
        //设置路径状态7
        [path setLineWidth:3];
        [[UIColor colorWithRed:7/255.0 green:139/255.0 blue:215/255.0 alpha:1] set];
        [path setLineJoinStyle:kCGLineJoinRound];
        
        [path stroke];
    }
    
}

- (NSMutableArray *)selectButtonArray {
    if (_selectButtonArray == nil) {
        _selectButtonArray = [NSMutableArray array];
    }
    return _selectButtonArray;
}

@end
