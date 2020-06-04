//
//  TMCaptureController.h
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMCaptureType) {
    TMCaptureTypeAll,
    TMCaptureTypePhoto,
    TMCaptureTypeVideo
};

@interface TMCaptureController : UIViewController

@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^completionBlock)(UIImage* image, NSString *imagePath, NSString *videoPath, PHAsset *asset);
@property (nonatomic, assign) TMCaptureType captureType;

@end

NS_ASSUME_NONNULL_END

/**
使用：
TMCaptureController *c = [TMCaptureController new];
c.completionBlock = ^(UIImage* image, NSString *imagePath, NSString *videoPath, PHAsset *asset) {
};
c.modalPresentationStyle = UIModalPresentationFullScreen;
[self presentViewController:c animated:YES completion:nil];
*/
