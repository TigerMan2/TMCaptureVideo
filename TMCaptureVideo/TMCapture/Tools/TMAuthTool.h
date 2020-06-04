//
//  TMAuthTool.h
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

/**
 权限管理,用于获取相机/相册权限问题
 */

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMAuthTool : NSObject

/// 获取相册授权
/// @param authBlock 授权回调
+ (void)getPhotoAlbumAuth:(void(^)(BOOL success, BOOL grantedJustNow))authBlock;

/// 根据媒体类型获取授权
/// @param mediaType 媒体类型
/// @param authBlock 授权回调
+ (void)getAVMediaTypeAuth:(AVMediaType)mediaType authBlock:(void(^)(BOOL success, BOOL grantedJustNow))authBlock;

/// 获取相册权限，不成功弹框警告
/// @param authBlock 授权回调
/// @param clickBlock 点击回调 -1:不允许 0:取消 1:去设置
+ (void)getPhotoAlbumAuthSetting:(void(^)(BOOL success))authBlock clickBlock:(void(^)(NSInteger index))clickBlock;

/// 获取摄像权限，不成功弹框警告
/// @param authBlock 授权回调
/// @param clickBlock 点击回调
+ (void)getVideoAuthSetting:(void(^)(void))authBlock clickBlock:(void(^)(void))clickBlock;

/// 获取麦克风权限，不成功弹框警告
/// @param authBlock 授权回调
/// @param clickBlock 点击回调
+ (void)getAudioAuthSetting:(void(^)(void))authBlock clickBlock:(void(^)(void))clickBlock;

/// 获取摄像和麦克风权限
/// @param authBlock 成功回调
/// @param clickBlock 警告框点击或不允许回调
+ (void)getVideoAudioAuthSetting:(void(^)(void))authBlock clickBlock:(void(^)(void))clickBlock;

/// 授权警告框
/// @param message 提示内容
/// @param block 点击回调
+ (void)settingAlertWithMessage:(NSString *)message block:(void(^)(NSInteger index))block;

@end

NS_ASSUME_NONNULL_END
