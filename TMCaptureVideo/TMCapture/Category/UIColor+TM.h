//
//  NSString+TM.h
//  TMRecordVideo
//
//  Created by Luther on 2020/6/2.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (TM)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor*)colorWithHex:(int)hex;
+ (UIColor*)colorWithHex:(int)hex alpha:(float) alpha;

@end

NS_ASSUME_NONNULL_END
