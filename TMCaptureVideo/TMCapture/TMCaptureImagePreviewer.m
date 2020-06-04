//
//  TMCaptureImagePreviewer.m
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "TMCaptureImagePreviewer.h"
#import "TMDefine.h"
#import "TMCategoryHeader.h"

@interface TMCaptureImagePreviewer ()
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation TMCaptureImagePreviewer

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *resultImageView = [[UIImageView alloc] initWithImage:self.image];
    resultImageView.frame = self.bounds;
    resultImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:resultImageView];
    self.resultImageView = resultImageView;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(12, TMNavY(20), 44, 44)];
    [backButton setImage:TMImage(@"tm_capture_back") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 33)];
    doneButton.tm_bottom = self.bounds.size.height - (TMSafeH+20);
    doneButton.tm_right = self.bounds.size.width - 20;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [doneButton setBackgroundColor:[UIColor colorWithHex:0x2883e0]];
    doneButton.layer.cornerRadius = 4;
    doneButton.layer.masksToBounds = YES;
    [doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
}

- (void)backClick {
    if (self.backBlock) {
        self.backBlock();
    }
    [self removeFromSuperview];
}

- (void)doneClick {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

@end
