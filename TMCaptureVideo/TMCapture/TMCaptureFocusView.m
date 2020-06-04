//
//  TMCaptureFocusView.m
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "TMCaptureFocusView.h"
#import "TMCategoryHeader.h"

@interface TMCaptureFocusView()
@property (nonatomic, strong) UIBezierPath *borderPath;
@end

@implementation TMCaptureFocusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderPath = [UIBezierPath bezierPath];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        self.borderPath = [UIBezierPath bezierPath];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.borderPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.borderPath.lineCapStyle = kCGLineCapButt;//线条拐角
    self.borderPath.lineWidth = 2.0;
    UIColor *color = [UIColor colorWithHex:0xe50010];
    [color set];// 设置边框线条颜色
    
    //连线 上
    [self.borderPath moveToPoint:CGPointMake(rect.size.width/2.0, 0)];
    [self.borderPath addLineToPoint:CGPointMake(rect.size.width/2.0, 0+8)];
    
    //连线 左
    [self.borderPath moveToPoint:CGPointMake(0, rect.size.width/2.0)];
    [self.borderPath addLineToPoint:CGPointMake(0+8, rect.size.width/2.0)];
    
    //连线 下
    [self.borderPath moveToPoint:CGPointMake(rect.size.width/2.0, rect.size.height)];
    [self.borderPath addLineToPoint:CGPointMake(rect.size.width/2.0, rect.size.height - 8)];
    
    //连线 右
    [self.borderPath moveToPoint:CGPointMake(rect.size.width, rect.size.height/2.0)];
    [self.borderPath addLineToPoint:CGPointMake(rect.size.width - 8, rect.size.height/2.0)];
    
    [self.borderPath stroke];
}

@end
