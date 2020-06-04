//
//  ViewController.m
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#import "ViewController.h"
#import "TMCaptureController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.center = self.view.center;
    [button setTitle:@"拍摄小视频" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick {
    TMCaptureController *v = [[TMCaptureController alloc] init];
    v.completionBlock = ^(UIImage * _Nonnull image, NSString * _Nonnull imagePath, NSString * _Nonnull videoPath, PHAsset * _Nonnull asset) {
        NSLog(@"image:%@",image);
        NSLog(@"imagePath:%@",imagePath);
        NSLog(@"videoPath:%@",videoPath);
        NSLog(@"asset:%@",asset);
    };
    [self presentViewController:v animated:YES completion:nil];
}


@end
