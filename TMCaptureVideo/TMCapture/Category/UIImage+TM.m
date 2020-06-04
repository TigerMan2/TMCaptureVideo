//
//  UIImage+TM.m
//  TMRecordVideo
//
//  Created by Luther on 2020/6/2.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "UIImage+TM.h"
#import <AVFoundation/AVTime.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>

@implementation UIImage (TM)

// 获取视频第一帧
+ (UIImage*)dx_videoFirstFrameWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

@end
