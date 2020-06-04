//
//  TMCaptureTool.m
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "TMCaptureTool.h"
#import "TMDefine.h"
#import <UIKit/UIKit.h>

@implementation TMCaptureTool

/// 保存图片到相册库
/// @param image 图片
/// @param completion 回调
+ (void)saveImageToPhotoLibrary:(UIImage *)image completion:(void(^)(PHAsset *asset, NSString *errorMessage))completion {
    [self getPhotoAlbumAuthWithSuccess:^{
        __block NSString *localIdentifier = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
           PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
            request.creationDate = [NSDate date];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            TM_DISPATCH_ON_MAIN_THREAD(^{
                if (success) {
                    PHAsset *asset = [[PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil] firstObject];
                    if (completion) completion(asset,nil);
                } else if (error) {
                    NSLog(@"保存照片失败 %@",error.localizedDescription);
                    if (completion) completion(nil,[NSString stringWithFormat:@"保存照片失败 %@",error.localizedDescription]);
                }
            });
        }];
    } failure:^{
        if (completion) completion(nil,@"没有相册权限");
    }];
}

/// 保存视频到相册中
/// @param url 视频PathURL
/// @param completion 回调
+ (void)saveVideoToPhotoLibrary:(NSURL *)url completion:(void(^)(PHAsset *asset, NSString *errorMessage))completion {
    [self getPhotoAlbumAuthWithSuccess:^{
        __block NSString *localIdentifier = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
           PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
            request.creationDate = [NSDate date];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            TM_DISPATCH_ON_MAIN_THREAD(^{
                if (success) {
                    PHAsset *asset = [[PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil] firstObject];
                    if (completion) completion(asset,nil);
                } else if (error) {
                    NSLog(@"保存视频失败 %@",error.localizedDescription);
                    if (completion) completion(nil,[NSString stringWithFormat:@"保存视频失败 %@",error.localizedDescription]);
                }
            });
        }];
    } failure:^{
        if (completion) completion(nil,@"没有相册权限");
    }];
}

/// 获取相册权限
/// @param success 成功
/// @param failure 失败
+ (void)getPhotoAlbumAuthWithSuccess:(void(^)(void))success failure:(void(^)(void))failure {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            if (failure) failure();
            break;
        case PHAuthorizationStatusNotDetermined:
            {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    TM_DISPATCH_ON_MAIN_THREAD(^{
                        if (status == PHAuthorizationStatusAuthorized) {
                           if (success) success();
                        } else {
                            if (failure) failure();
                        }
                    });
                }];
            }
            break;
        case PHAuthorizationStatusAuthorized:
            if (success) success();
            break;
        default:
            break;
    }
}

/// 保存图片到沙盒临时目录，返回保存路径
/// @param image 图片
+ (NSString *)saveImageToSandBoxTempDir:(UIImage *)image {
    [self createCaptureTempDirIfNotExist];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *filePath = [TMCaptureTempDir stringByAppendingPathComponent:@"tm_capture_image.png"];
    NSURL *url = [NSURL URLWithString:filePath];
    [imageData writeToURL:url atomically:YES];
    return filePath;
}

+ (void)createCaptureTempDirIfNotExist {
    if (![[NSFileManager defaultManager] fileExistsAtPath:TMCaptureTempDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:TMCaptureTempDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
