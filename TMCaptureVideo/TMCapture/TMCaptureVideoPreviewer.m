//
//  TMCaptureVideoPreviewer.m
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "TMCaptureVideoPreviewer.h"
#import <AVFoundation/AVFoundation.h>
#import "TMDefine.h"
#import "TMCategoryHeader.h"

@interface TMCaptureVideoPreviewer ()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation TMCaptureVideoPreviewer

- (id)initWithFrame:(CGRect)frame playURL:(NSURL*)playURL {
    self = [super initWithFrame:frame];
    if (self) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playURL];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addObserverToPlayerItem:playerItem];
        [self.layer addSublayer:self.playerLayer];
        [self.player play];
        [self setupItems];
        
    }
    return self;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerLayer;
}


- (void)setupItems {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(12, TMNavY(20), 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"dx_circle_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 33)];
    doneButton.tm_bottom = self.bounds.size.height - (TMSafeH+20);
    doneButton.tm_right = self.bounds.size.width - 20;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [doneButton setBackgroundColor:[UIColor colorWithHex:0x2883e0]];
    doneButton.layer.cornerRadius = 4;
    doneButton.layer.masksToBounds = YES;
    [doneButton addTarget:self action:@selector(onConfirmBlock) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
}

- (void)onBackClick {
    if (self.backBlock) {
        self.backBlock();
    }
    [self.player pause];
    [self removeFromSuperview];
}


- (void)onConfirmBlock {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self.player pause];
}

- (void)playbackFinished:(NSNotification *)notification{
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

- (void)dealloc{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
