//
//  UIView+TMFrame.h
//  TMKit
//
//  Created by Luther on 2019/9/22.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TM)

@property (nonatomic) CGFloat tm_x;
@property (nonatomic) CGFloat tm_y;

@property (nonatomic) CGFloat tm_centerX;
@property (nonatomic) CGFloat tm_centerY;

@property (nonatomic) CGFloat tm_maxX;
@property (nonatomic) CGFloat tm_maxY;

@property (nonatomic) CGFloat tm_width;
@property (nonatomic) CGFloat tm_height;

@property (nonatomic) CGSize tm_size;
@property (nonatomic) CGPoint tm_origin;

@property (nonatomic) CGFloat tm_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat tm_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat tm_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat tm_bottom;      ///< Shortcut for frame.origin.y + frame.size.height

@end

NS_ASSUME_NONNULL_END
