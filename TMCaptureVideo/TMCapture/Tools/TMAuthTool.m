//
//  TMAuthTool.m
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "TMAuthTool.h"
#import "TMCategoryHeader.h"
#import "TMDefine.h"

@implementation TMAuthTool

/// 获取相册授权
/// @param authBlock 授权回调
+ (void)getPhotoAlbumAuth:(void(^)(BOOL success, BOOL grantedJustNow))authBlock {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            if (authBlock) authBlock(NO,NO);
            break;
        case PHAuthorizationStatusNotDetermined:
            {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    TM_DISPATCH_ON_MAIN_THREAD(^{
                        if (status == PHAuthorizationStatusAuthorized) {
                            if (authBlock) authBlock(YES,YES);
                        } else {
                            if (authBlock) authBlock(NO,YES);
                        }
                    });
                }];
            }
            break;
        case PHAuthorizationStatusAuthorized:
            if (authBlock) authBlock(YES,NO);
            break;
        default:
            break;
    }
}

/// 根据媒体类型获取授权
/// @param mediaType 媒体类型
/// @param authBlock 授权回调
+ (void)getAVMediaTypeAuth:(AVMediaType)mediaType authBlock:(void(^)(BOOL success, BOOL grantedJustNow))authBlock {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus) {
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            if (authBlock) authBlock(NO,NO);
            break;
        case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                    TM_DISPATCH_ON_MAIN_THREAD(^{
                        if (authBlock) authBlock(granted,YES);
                    });
                }];
            }
            break;
        case AVAuthorizationStatusAuthorized:
            if (authBlock) authBlock(YES,NO);
            break;
            
        default:
            break;
    }
}

/// 获取相册权限，不成功弹框警告
/// @param authBlock 授权回调
/// @param clickBlock 点击回调 -1:不允许 0:取消 1:去设置
+ (void)getPhotoAlbumAuthSetting:(void(^)(BOOL success))authBlock clickBlock:(void(^)(NSInteger index))clickBlock {
    [self getPhotoAlbumAuth:^(BOOL success, BOOL grantedJustNow) {
        if (!success && !grantedJustNow) {
            [self settingAlertWithMessage:@"请前往设置打开相册权限" block:^(NSInteger index) {
                if (clickBlock) clickBlock(index);
            }];
        } else if (!success && grantedJustNow) {
            if (clickBlock) clickBlock(-1); //首次系统弹出的提示框
        }
        if (authBlock) authBlock(success);
    }];
}

/// 获取摄像权限，不成功弹框警告
/// @param authBlock 授权回调
/// @param clickBlock 点击回调
+ (void)getVideoAuthSetting:(void(^)(void))authBlock clickBlock:(void(^)(void))clickBlock {
    [self getAVMediaTypeAuth:AVMediaTypeVideo authBlock:^(BOOL success, BOOL grantedJustNow) {
        if (success) {
            if (authBlock) authBlock();
        } else if (grantedJustNow) {
            if (clickBlock) clickBlock();
        } else {
            [self settingAlertWithMessage:@"请前往设置打开相机权限" block:^(NSInteger index) {
                if (clickBlock) clickBlock();
            }];
        }
    }];
}

/// 获取麦克风权限，不成功弹框警告
/// @param authBlock 授权回调
/// @param clickBlock 点击回调
+ (void)getAudioAuthSetting:(void(^)(void))authBlock clickBlock:(void(^)(void))clickBlock {
    [self getAVMediaTypeAuth:AVMediaTypeAudio authBlock:^(BOOL success, BOOL grantedJustNow) {
        if (success) {
            if (authBlock) authBlock();
        } else if (grantedJustNow) {
            if (clickBlock) clickBlock();
        } else {
            [self settingAlertWithMessage:@"请前往设置打开麦克风权限" block:^(NSInteger index) {
                if (clickBlock) clickBlock();
            }];
        }
    }];
}

/// 获取摄像和麦克风权限
/// @param authBlock 成功回调
/// @param clickBlock 警告框点击或不允许回调
+ (void)getVideoAudioAuthSetting:(void(^)(void))authBlock clickBlock:(void(^)(void))clickBlock {
    [self getVideoAuthSetting:^{
        [self getAudioAuthSetting:authBlock clickBlock:clickBlock];
    } clickBlock:clickBlock];
}

/// 授权警告框
/// @param message 提示内容
/// @param block 点击回调
+ (void)settingAlertWithMessage:(NSString *)message block:(void(^)(NSInteger index))block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(0);
        }
    }];
    //去设置
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openSetting];
        if (block) {
            block(1);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingAction];
    UIViewController *currentController = [UIApplication sharedApplication].delegate.window.rootViewController.currentTopViewController;
    [currentController presentViewController:alertController animated:YES completion:nil];
}

/// 打开设置
+ (void)openSetting {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

@end
