//
//  TMCaptureTool.h
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMCaptureTool : NSObject

/// 保存图片到相册库
/// @param image 图片
/// @param completion 回调
+ (void)saveImageToPhotoLibrary:(UIImage *)image completion:(void(^)(PHAsset *asset, NSString *errorMessage))completion;

/// 保存视频到相册中
/// @param url 视频PathURL
/// @param completion 回调
+ (void)saveVideoToPhotoLibrary:(NSURL *)url completion:(void(^)(PHAsset *asset, NSString *errorMessage))completion;

/// 保存图片到沙盒临时目录，返回保存路径
/// @param image 图片
+ (NSString *)saveImageToSandBoxTempDir:(UIImage *)image;

/// 创建缓存文件(如果不存在)
+ (void)createCaptureTempDirIfNotExist;

@end

NS_ASSUME_NONNULL_END
