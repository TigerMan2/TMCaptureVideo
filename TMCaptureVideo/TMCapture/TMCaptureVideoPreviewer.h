//
//  TMCaptureVideoPreviewer.h
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMCaptureVideoPreviewer : UIView

@property (nonatomic, copy) void(^backBlock)(void);
@property (nonatomic, copy) void(^confirmBlock)(void);

- (id)initWithFrame:(CGRect)frame playURL:(NSURL*)playURL;

@end

NS_ASSUME_NONNULL_END
