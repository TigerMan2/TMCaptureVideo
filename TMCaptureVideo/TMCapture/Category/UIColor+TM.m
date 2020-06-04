//
//  NSString+TM.m
//  TMRecordVideo
//
//  Created by Luther on 2020/6/2.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "UIColor+TM.h"

@implementation UIColor (TM)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    //!< 删除字符串中的空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    
    //!< hexString should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //!< 如果是0x开头的，则从位置2截取字符串
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    
    //!< 如果是#开头的，则从位置1截取字符串
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    //!< 获取r, g, b
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //!< scan r, g, b
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

/**
 *  将十六进制数字转换为UIColor
 *
 *  @param hex 十六进制数字
 *
 *  @return UIColor
 */
+ (UIColor*)colorWithHex:(int)hex {
    
//    float red = ((hex & 0xFF0000) >> 16)/255.0;
//    float green = ((hex & 0xFF00) >> 8)/255.0;
//    float blue = (hex & 0xFF)/255.0;
//    NSLog(@"red = %f green = %f blue = %f",red,green,blue);
    
    return [self colorWithHex:hex alpha:1.0];
}

+ (UIColor*)colorWithHex:(int)hex alpha:(float) alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0
                           alpha:alpha];
    
}

@end
