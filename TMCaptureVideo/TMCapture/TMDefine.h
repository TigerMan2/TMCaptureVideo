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


#endif /* TMDefine_h */
