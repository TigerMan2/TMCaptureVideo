//
//  TMDefine.h
//  TMCaptureVideo
//
//  Created by Luther on 2020/6/4.
//  Copyright © 2020 mrstock. All rights reserved.
//

#ifndef TMDefine_h
#define TMDefine_h

///主线程操作
#define TM_DISPATCH_ON_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(),mainQueueBlock);

///存储图片的沙盒地址
#define TMCaptureTempDir [NSTemporaryDirectory() stringByAppendingPathComponent:@"capture"]

///加载图片
#define TMImage(imageName) [UIImage imageNamed:imageName]

///尺寸
#define iPhoneQLH ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
#define TMNavY(R) (iPhoneQLH ? R+24 : R)
#define TMSafeH   (iPhoneQLH ? 34 : 0)
#define TMNavH    (iPhoneQLH ? 88 : 64)


#endif /* TMDefine_h */
