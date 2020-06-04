//
//  TMCaptureTimer.h
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMCaptureTimer : NSObject
@property (nonatomic, assign) CGFloat maxCaptureTime;

@property (nonatomic, copy) void(^progressBlock)(CGFloat);
@property (nonatomic, copy) void(^progressCancelBlock)(void);
@property (nonatomic, copy) void(^progressFinishBlock)(void);

- (void)startTimer;
- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
