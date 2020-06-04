//
//  TMCaptureImagePreviewer.h
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMCaptureImagePreviewer : UIView

@property (nonatomic, copy) void (^backBlock)(void);
@property (nonatomic, copy) void (^doneBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
