//
//  TMCaptureTimer.m
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "TMCaptureTimer.h"
#import "TMDefine.h"

@interface TMCaptureTimer ()
@property (nonatomic, strong) dispatch_source_t gcdTimer;
@property (nonatomic, assign) CGFloat captureDuration;
@end

@implementation TMCaptureTimer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCaptureTime = 15.0f;
    }
    return self;
}

- (void)startTimer {
    /** 创建定时器对象
    * para1: DISPATCH_SOURCE_TYPE_TIMER 为定时器类型
    * para2-3: 中间两个参数对定时器无用
    * para4: 最后为在什么调度队列中使用
    */
    self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    /** 设置定时器
    * para2: 任务开始时间
    * para3: 任务的间隔
    * para4: 可接受的误差时间，设置0即不允许出现误差
    * Tips: 单位均为纳秒
    */
    //定时器延时时间
    NSTimeInterval delayTime = 0.f;
    //定时器间隔时间
    NSTimeInterval timeInterval = 0.1f;
    //设置开始时间
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(delayTime * NSEC_PER_SEC));
    dispatch_source_set_timer(self.gcdTimer, startDelayTime, timeInterval * NSEC_PER_SEC, timeInterval * NSEC_PER_SEC);
    /** 设置定时器任务
    * 可以通过block方式
    * 也可以通过C函数方式
    */
    dispatch_source_set_event_handler(self.gcdTimer, ^{
        self.captureDuration += timeInterval;
        //主线程更新UI
        TM_DISPATCH_ON_MAIN_THREAD(^{
            if (self.progressBlock) {
                self.progressBlock(self.captureDuration/self.maxCaptureTime);
            }
        });
        
        //完成
        if (self.captureDuration >= self.maxCaptureTime) {
            //取消定时器
            [self cancel];
            TM_DISPATCH_ON_MAIN_THREAD(^{
                if (self.progressFinishBlock) self.progressFinishBlock();
            });
        }
    });
    //启动任务，GCD定时器创建后需要手动启动
    dispatch_resume(self.gcdTimer);
}

- (void)stopTimer {
    [self cancel];
    TM_DISPATCH_ON_MAIN_THREAD(^{
        if (self.progressCancelBlock) self.progressCancelBlock();
    });
}

- (void)cancel {
    if (self.gcdTimer) {
        dispatch_source_cancel(self.gcdTimer);
        self.gcdTimer = nil;
    }
    self.captureDuration = 0;
}

@end
