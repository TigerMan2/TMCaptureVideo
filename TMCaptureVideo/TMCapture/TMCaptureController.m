//
//  TMCaptureController.m
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "TMCaptureController.h"
#import "TMDefine.h"
#import "TMAuthTool.h"
#import "TMCaptureTool.h"
#import "TMCategoryHeader.h"
#import "TMCaptureTimer.h"
#import "TMCaptureFocusView.h"
#import "TMCaptureEditExport.h"
#import "TMCaptureWriterInput.h"
#import "TMCaptureVideoSession.h"
#import "TMCaptureImagePreviewer.h"
#import "TMCaptureVideoPreviewer.h"

@interface TMCaptureController ()
<
    TMCaptureVideoSessionDelegate,
    TMCaptureWriterInputDelegate
>

@property (nonatomic, strong) TMCaptureVideoSession *avCaptureSession; //摄像头采集工具
@property (nonatomic, strong) TMCaptureWriterInput *avWriterInput;  //音视频写入输出文件

@property (nonatomic, strong) UIImageView *captureView; // 预览视图
@property (nonatomic, strong) UIButton *switchCameraBtn; // 切换前后摄像头
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *recordBtn;
@property (nonatomic, strong) UIView *recordBackView;


@property (nonatomic, strong) CAShapeLayer *progressLayer; //环形进度条
@property (nonatomic, strong)  UILabel *tipLabel; //拍摄提示语  轻触拍照 长按拍摄

@property (nonatomic, assign) CGFloat currentZoomFactor; //当前焦距比例系数
@property (nonatomic, strong) TMCaptureFocusView *focusView;   //当前聚焦视图

@property (nonatomic, assign) BOOL isRecording; //是否正在录制

@property (nonatomic, strong) CIContext* context;

@property (nonatomic, strong) TMCaptureTimer *timer;

@end

@implementation TMCaptureController

#pragma mark - OverWrite
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startCapture];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.recordBtn.userInteractionEnabled = YES;

    [self addKVO];
    
    [TMAuthTool getVideoAudioAuthSetting:^{
    } clickBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopCapture];
    [self removeKVO];
}

- (void)dealloc {
    _avCaptureSession.delegate = nil;
    _avCaptureSession = nil;
}

- (void)startCapture {
    [self.avCaptureSession startRunning];
    [self focusAtPoint:CGPointMake(TMSCREEN_WIDTH/2.0, TMSCREEN_HEIGHT/2.0)];
    self.tipLabel.hidden = NO;
}

- (void)stopCapture {
    [self.timer stopTimer];
    
    self.isRecording = NO;
    [self.avCaptureSession stopRunning];
}

#pragma mark - kVO
- (void)addKVO {
    [self.avCaptureSession addObserver:self forKeyPath:@"shootingOrientation" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVO {
    [self.avCaptureSession removeObserver:self forKeyPath:@"shootingOrientation"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"shootingOrientation"]) {
        UIDeviceOrientation deviceOrientation = [change[@"new"] intValue];
        [UIView animateWithDuration:0.3 animations:^{
            switch (deviceOrientation) {
                case UIDeviceOrientationPortrait:
                    self.switchCameraBtn.transform = CGAffineTransformMakeRotation(0);
                    break;
                case UIDeviceOrientationLandscapeLeft:
                    self.switchCameraBtn.transform = CGAffineTransformMakeRotation(M_PI/2.0);
                    break;
                case UIDeviceOrientationLandscapeRight:
                    self.switchCameraBtn.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    self.switchCameraBtn.transform = CGAffineTransformMakeRotation(-M_PI);
                    break;
                default:
                    break;
            }
        }];
    }
}


#pragma mark - UI
- (void)setupUI {
    [self.view addSubview:self.captureView];
    
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.recordBackView];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.switchCameraBtn];
    [self.view addSubview:self.tipLabel];
    
    self.recordBtn.userInteractionEnabled = NO;
}

#pragma mark - Getter
- (TMCaptureVideoSession *)avCaptureSession {
    if (_avCaptureSession == nil) {
        _avCaptureSession = [[TMCaptureVideoSession alloc] init];
        _avCaptureSession.delegate = self;
    }
    return _avCaptureSession;
}

- (TMCaptureWriterInput *)avWriterInput {
    if (!_avWriterInput) {
        _avWriterInput = [[TMCaptureWriterInput alloc] init];
        _avWriterInput.delegate = self;
    }
    return _avWriterInput;
}

- (TMCaptureTimer *)timer {
    if (!_timer) {
        _timer = [TMCaptureTimer new];
        TMWS(weakSelf);
        _timer.progressBlock = ^(CGFloat value) {
            weakSelf.progressLayer.strokeEnd = value;
        };
        _timer.progressFinishBlock = ^{
            weakSelf.progressLayer.strokeEnd = 1;
            [weakSelf stopRecord];
        };
        _timer.progressCancelBlock = ^{
            weakSelf.progressLayer.strokeEnd = 0;
        };
    }
    return _timer;
}

- (UIImageView *)captureView {
    if (!_captureView) {
        _captureView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _captureView.contentMode = UIViewContentModeScaleAspectFit;
        _captureView.backgroundColor = [UIColor blackColor];
        _captureView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFocusing:)];
        [_captureView addGestureRecognizer:tap];
        UIPinchGestureRecognizer  *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFocalLength:)];
        [_captureView addGestureRecognizer:pinch];
    }
    return _captureView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(60, 0, 44, 44);
        _backBtn.tm_centerY = self.recordBackView.tm_centerY;
        _backBtn.tm_right = self.recordBackView.tm_left - 40;
        [_backBtn setImage:TMImage(@"tm_capture_close") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)recordBackView {
    if (!_recordBackView) {
        CGRect rect = self.recordBtn.frame;
        CGFloat gap = 10;
        CGFloat size = rect.size.width + gap*2;
        rect.size = CGSizeMake(size, size);
        rect.origin = CGPointMake(rect.origin.x - gap, rect.origin.y - gap);
        _recordBackView = [[UIView alloc]initWithFrame:rect];
        _recordBackView.backgroundColor = [UIColor whiteColor];
        _recordBackView.alpha = .5;
        [_recordBackView.layer setCornerRadius:size/2];
    }
    return _recordBackView;
}

-(UIView *)recordBtn {
    if (!_recordBtn) {
        CGFloat width = 60;
        _recordBtn = [[UIView alloc]initWithFrame:CGRectMake(0,0, width, width)];
        _recordBtn.tm_centerX = self.view.tm_width/2;
        _recordBtn.tm_bottom = self.view.tm_height - (TMSafeH + 40);
        [_recordBtn.layer setCornerRadius:width/2];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        if (self.captureType != TMCaptureTypePhoto ) {
            UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(recordVideo:)];
            [_recordBtn addGestureRecognizer:press];
        }
        if (self.captureType != TMCaptureTypeVideo) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTakePhoto:)];
            [_recordBtn addGestureRecognizer:tap];
        }
        _recordBtn.userInteractionEnabled = YES;
    }
    return _recordBtn;
}

- (UIButton *)switchCameraBtn {
    if (!_switchCameraBtn) {
        _switchCameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.tm_width - 44 - 15, TMNavY(25) , 44, 44)];
        [_switchCameraBtn setImage:TMImage(@"tm_capture_switchCamera") forState:UIControlStateNormal];
        [_switchCameraBtn addTarget:self action:@selector(switchCameraClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        CGRect rect = CGRectInset(self.recordBackView.bounds, 2.5, 2.5);
        CGFloat radius = rect.size.width/2;
        //设置画笔路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:- M_PI_2 endAngle:-M_PI_2 + M_PI * 2 clockwise:YES];
        //按照路径绘制圆环
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = rect;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = 5;
        //线头的样式
        _progressLayer.lineCap = kCALineCapButt;
        //圆环颜色
        _progressLayer.strokeColor = [UIColor colorWithHex:0x2daf2d].CGColor;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        //path 决定layer将被渲染成何种形状
        _progressLayer.path = path.CGPath;
    }
    return _progressLayer;
}

- (TMCaptureFocusView *)focusView {
    if (!_focusView) {
        _focusView= [[TMCaptureFocusView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    }
    return _focusView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.recordBackView.tm_y - 20 - 30, 200, 30)];
        _tipLabel.tm_centerX = self.view.tm_width/2;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = [self tip];
    }
    return _tipLabel;
}

- (NSString*)tip {
    if (self.captureType == TMCaptureTypePhoto) {
        return @"轻触拍照";
    }
    if (self.captureType == TMCaptureTypeVideo) {
        return @"长按拍摄";
    }
    return @"轻触拍照，长按摄像";
}

-(CIContext *)context {
    // default creates a context based on GPU
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

#pragma mark - EventsHandle
- (void)backBtn:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//聚焦手势
- (void)tapFocusing:(UITapGestureRecognizer *)tap {
    //如果没在运行，取消聚焦
    if(!self.avCaptureSession.isRunning) {
        return;
    }
    CGPoint point = [tap locationInView:self.captureView];
    if(point.y > self.recordBackView.tm_y || point.y < self.switchCameraBtn.tm_y + self.switchCameraBtn.tm_height) {
        return;
    }
    [self focusAtPoint:point];
}

//设置焦点视图位置
- (void)focusAtPoint:(CGPoint)point {
    [self.avCaptureSession focusAtPoint:point];
}

//调节焦距 手势
- (void)pinchFocalLength:(UIPinchGestureRecognizer *)pinch {
    if(pinch.state == UIGestureRecognizerStateBegan) {
        self.currentZoomFactor = self.avCaptureSession.videoZoomFactor;
    }
    if (pinch.state == UIGestureRecognizerStateChanged) {
        self.avCaptureSession.videoZoomFactor = self.currentZoomFactor * pinch.scale;
    }
}

//切换前/后摄像头
- (void)switchCameraClicked:(id)sender {
    if (self.avCaptureSession.devicePosition == AVCaptureDevicePositionFront) {
        [self.avCaptureSession switchsCamera:AVCaptureDevicePositionBack];
    } else if(self.avCaptureSession.devicePosition == AVCaptureDevicePositionBack) {
        [self.avCaptureSession switchsCamera:AVCaptureDevicePositionFront];
    }
}

//轻触拍照
- (void)onTakePhoto:(UITapGestureRecognizer *)tap {
    [self stopCapture];

    UIImageOrientation imageOrientation = UIImageOrientationUp;
    switch (self.avCaptureSession.shootingOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            imageOrientation = UIImageOrientationLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            imageOrientation = UIImageOrientationRight;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            imageOrientation = UIImageOrientationDown;
            break;
        default:
            break;
    }

    UIImage *image = [UIImage imageWithCGImage:self.captureView.image.CGImage scale:[UIScreen mainScreen].scale orientation:imageOrientation];
    self.captureView.image = image;
    
    TMWS(weakSelf);
    TMCaptureImagePreviewer *v = [[TMCaptureImagePreviewer alloc] initWithFrame:self.view.bounds image:self.captureView.image];
    [self.view addSubview:v];
    v.backBlock = ^{
        [weakSelf startCapture];
    };
    v.doneBlock = ^{
        //保存到相册，没有权限走出错处理
        [TMCaptureTool saveImageToPhotoLibrary:image completion:^(PHAsset * _Nonnull asset, NSString * _Nonnull errorString) {
            if (errorString) {
                NSLog(@"%@",errorString);
                [weakSelf finishWithImage:image asset:nil videoPath:nil];
            } else {
                [weakSelf finishWithImage:image asset:asset videoPath:nil];
            }
        }];
    };
}

//长按摄像 小视频
- (void)recordVideo:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            [self startRecord];
            break;
        }
        case UIGestureRecognizerStateChanged:{
             // NSLog(@"正在摄像");
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self stopRecord];
            break;
        }
        default:
            break;
    }
}

//开始录制视频
- (void)startRecord {
    self.tipLabel.hidden = YES;
    self.switchCameraBtn.hidden = YES;
    self.backBtn.hidden = YES;
    
    self.recordBackView.backgroundColor = [UIColor colorWithHex:0xe2e2e2];
    self.recordBackView.alpha = 1;
    //添加进度条
    [self.recordBackView.layer addSublayer:self.progressLayer];
    self.progressLayer.strokeEnd = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.recordBtn.transform = CGAffineTransformMakeScale(.5, .5);
        self.recordBackView.transform = CGAffineTransformMakeScale(1.125, 1.125);
    }];
    
    //开始计时
    [self.timer startTimer];
    
    [TMCaptureTool createCaptureTempDirIfNotExist];
    NSString *outputVideoFielPath = [TMCaptureTempDir stringByAppendingPathComponent:@"tm_tmp_video.mp4"];
    [self.avWriterInput startWritingToOutputFileAtPath:outputVideoFielPath fileType:TMCaptureAudioSessionTypeVideo deviceOrientation:self.avCaptureSession.shootingOrientation];
    self.isRecording = YES;
}

//结束录制视频
- (void)stopRecord {
    if (!self.isRecording) {
        return;
    }
    
    self.recordBackView.backgroundColor = [UIColor whiteColor];
    self.recordBackView.alpha = .5;
    [UIView animateWithDuration:0.2 animations:^{
        self.recordBtn.transform = CGAffineTransformIdentity;
        self.recordBackView.transform = CGAffineTransformIdentity;
    }];
  
    [self.progressLayer removeFromSuperlayer];
    self.progressLayer.strokeEnd = 0;

    //    结束录制视频
    [self.avCaptureSession stopRunning];
    [self.avWriterInput finishWriting];
    self.isRecording = NO;
    [self.timer stopTimer];
    
    self.switchCameraBtn.hidden = NO;
    self.backBtn.hidden = NO;
}

#pragma mark - SLAvCaptureSessionDelegate 音视频实时输出代理
//实时输出视频样本
- (void)captureSession:(TMCaptureVideoSession * _Nullable)captureSession didOutputVideoSampleBuffer:(CMSampleBufferRef _Nullable)sampleBuffer fromConnection:(AVCaptureConnection * _Nullable)connection {
    @autoreleasepool {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CIImage* image = [CIImage imageWithCVImageBuffer:imageBuffer];
        
        CGImageRef filterImageRef = [self.context createCGImage:image fromRect:image.extent];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.captureView.image = [UIImage imageWithCGImage:filterImageRef];
            CGImageRelease(filterImageRef);
        });
        if (self.isRecording) {
            [self.avWriterInput writingVideoSampleBuffer:sampleBuffer fromConnection:connection filterImage:nil];
        }
    }
}

//实时输出音频样本
- (void)captureSession:(TMCaptureVideoSession * _Nullable)captureSession didOutputAudioSampleBuffer:(CMSampleBufferRef _Nullable)sampleBuffer fromConnection:(AVCaptureConnection * _Nullable)connection {
    if (self.isRecording) {
        [self.avWriterInput writingAudioSampleBuffer:sampleBuffer fromConnection:connection];
    }
}

#pragma mark - SLAvWriterInputDelegate 音视频写入完成
//音视频写入完成
- (void)writerInput:(TMCaptureWriterInput *)writerInput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL error:(NSError *)error {
    [self stopCapture];
    [self showVideo:outputFileURL];
}

- (void)showVideo:(NSURL *)playURL {
    TMCaptureVideoPreviewer *playView= [[TMCaptureVideoPreviewer alloc]initWithFrame:self.view.bounds playURL:playURL];
    playView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:playView];
    TMWS(weakSelf);
    playView.backBlock = ^{
        [weakSelf startCapture];
    };
    playView.confirmBlock = ^{
        TMCaptureEditExport *videoExportSession = [[TMCaptureEditExport alloc] initWithAsset:[AVAsset assetWithURL:playURL]];
        [TMCaptureTool createCaptureTempDirIfNotExist];

        
        NSString *outputVideoFielPath = [TMCaptureTempDir stringByAppendingPathComponent:@"tm_capture_video.mp4"];
        NSURL *url = [NSURL fileURLWithPath:outputVideoFielPath];
        videoExportSession.outputURL = url;
        videoExportSession.isNativeAudio = YES;
        [videoExportSession exportAsynchronouslyWithCompletionHandler:^(NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@",error.localizedDescription);
            } else {
                //获取第一帧
                UIImage *cover = [UIImage dx_videoFirstFrameWithURL:url];
                //保存到相册，没有权限走出错处理
                [TMCaptureTool saveVideoToPhotoLibrary:url completion:^(PHAsset * _Nonnull asset, NSString * _Nonnull errorMessage) {
                    if (errorMessage) {  //保存失败
                        NSLog(@"%@",errorMessage);
                        [weakSelf finishWithImage:cover asset:nil videoPath:outputVideoFielPath];
                    } else {
                        [weakSelf finishWithImage:cover asset:asset videoPath:outputVideoFielPath];
                    }
                }];
            }
        } progress:^(float progress) {
            //NSLog(@"视频导出进度 %f",progress);
        }];
    };
}

- (void)finishWithImage:(UIImage*)image asset:(PHAsset*)asset videoPath:(NSString*)videoPath {
    NSString *imagePath = [TMCaptureTool saveImageToSandBoxTempDir:image];
    
    if (self.completionBlock) {
       self.completionBlock(image,imagePath,videoPath,asset);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
