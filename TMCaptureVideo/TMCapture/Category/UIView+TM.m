//
//  UIView+TMFrame.m
//  TMKit
//
//  Created by Luther on 2019/9/22.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "UIView+TM.h"

@implementation UIView (TM)

- (void)setTm_x:(CGFloat)tm_x {
    CGRect frame = self.frame;
    frame.origin.x = tm_x;
    self.frame = frame;
}

- (CGFloat)tm_x {
    return self.frame.origin.x;
}

- (void)setTm_y:(CGFloat)tm_y {
    CGRect frame = self.frame;
    frame.origin.y = tm_y;
    self.frame = frame;
}

- (CGFloat)tm_y {
    return self.frame.origin.y;
}

- (void)setTm_centerX:(CGFloat)tm_centerX {
    CGPoint center = self.center;
    center.x = tm_centerX;
    self.center = center;
}

- (CGFloat)tm_centerX {
    return self.center.x;
}

- (void)setTm_centerY:(CGFloat)tm_centerY {
    CGPoint center = self.center;
    center.y = tm_centerY;
    self.center = center;
}

- (CGFloat)tm_centerY {
    return self.center.y;
}

- (void)setTm_maxX:(CGFloat)tm_maxX {
    CGRect frame = self.frame;
    frame.origin.x = tm_maxX - frame.size.width;
    self.frame = frame;
}

- (CGFloat)tm_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setTm_maxY:(CGFloat)tm_maxY {
    CGRect frame = self.frame;
    frame.origin.y = tm_maxY - frame.size.height;
    self.frame = frame;
}

- (CGFloat)tm_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setTm_width:(CGFloat)tm_width {
    CGRect frame = self.frame;
    frame.size.width = tm_width;
    self.frame = frame;
}

- (CGFloat)tm_width {
    return self.frame.size.width;
}

- (void)setTm_height:(CGFloat)tm_height {
    CGRect frame = self.frame;
    frame.size.height = tm_height;
    self.frame = frame;
}

- (CGFloat)tm_height {
    return self.frame.size.height;
}

- (void)setTm_size:(CGSize)tm_size {
    CGRect frame = self.frame;
    frame.size = tm_size;
    self.frame = frame;
}

- (CGSize)tm_size {
    return self.frame.size;
}

- (void)setTm_origin:(CGPoint)tm_origin {
    CGRect frame = self.frame;
    frame.origin = tm_origin;
    self.frame = frame;
}

- (CGPoint)tm_origin {
    return self.frame.origin;
}

- (CGFloat)tm_left {
    return self.frame.origin.x;
}

- (void)setTm_left:(CGFloat)tm_left {
    CGRect frame = self.frame;
    frame.origin.x = tm_left;
    self.frame = frame;
}

- (CGFloat)tm_top {
    return self.frame.origin.y;
}

- (void)setTm_top:(CGFloat)tm_top {
    CGRect frame = self.frame;
    frame.origin.y = tm_top;
    self.frame = frame;
}

- (CGFloat)tm_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTm_right:(CGFloat)tm_right {
    CGRect frame = self.frame;
    frame.origin.x = tm_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)tm_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTm_bottom:(CGFloat)tm_bottom {
    CGRect frame = self.frame;
    frame.origin.y = tm_bottom - frame.size.height;
    self.frame = frame;
}

@end
