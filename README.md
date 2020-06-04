# TMCaptureVideo
利用AVFoundation实现视频/音频的录制，以及拍照功能

#### 使用
TMCaptureController *c = [TMCaptureController new];
c.completionBlock = ^(UIImage* image, NSString *imagePath, NSString *videoPath, PHAsset *asset) {
};
c.modalPresentationStyle = UIModalPresentationFullScreen;
[self presentViewController:c animated:YES completion:nil];

