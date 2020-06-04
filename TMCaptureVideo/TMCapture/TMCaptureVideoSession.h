//
//  TMCaptureVideoSession.h
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TMCaptureVideoSession;
/// 采集工具输出代理
@protocol TMCaptureVideoSessionDelegate <NSObject>
@optional
/// 实时输出采集的音视频样本  提供对外接口 方便自定义处理
/// @param captureSession 采集会话
/// @param sampleBuffer 缓冲样本
/// @param connection 输入和输出之前的连接
- (void)captureSession:(TMCaptureVideoSession *_Nullable)captureSession didOutputVideoSampleBuffer:(CMSampleBufferRef _Nullable )sampleBuffer fromConnection:(AVCaptureConnection *_Nullable)connection;
- (void)captureSession:(TMCaptureVideoSession *_Nullable)captureSession didOutputAudioSampleBuffer:(CMSampleBufferRef _Nullable )sampleBuffer fromConnection:(AVCaptureConnection *_Nullable)connection;
@end

@interface TMCaptureVideoSession : NSObject

/// 是否正在采集运行
@property (nonatomic, assign, readonly) BOOL isRunning;
/// 摄像头方向  默认后置摄像头
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;
/// 手机方向 只在 isRunning == YES时 才更新
@property (nonatomic, assign, readonly) UIDeviceOrientation shootingOrientation;
/// 闪光灯状态  默认是关闭的，即黑暗情况下拍照不打开闪光灯   （打开/关闭/自动）
@property (nonatomic, assign) AVCaptureFlashMode flashMode;
/// 当前焦距    默认最小值1  最大值6
@property (nonatomic, assign) CGFloat videoZoomFactor;
/// 捕获工具输出代理
@property (nonatomic, weak) id<TMCaptureVideoSessionDelegate> delegate;

///启动采集
- (void)startRunning;
///结束采集
- (void)stopRunning;
/// 聚焦点  默认是连续聚焦模式
- (void)focusAtPoint:(CGPoint)focalPoint;
/// 切换前/后置摄像头
- (void)switchsCamera:(AVCaptureDevicePosition)devicePosition;

@end

NS_ASSUME_NONNULL_END
