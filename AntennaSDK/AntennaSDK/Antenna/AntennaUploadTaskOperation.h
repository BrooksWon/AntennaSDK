//
//  AntennaUploadTaskOperation.h
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/14.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AntennaUploadTaskOperation : NSOperation
- (instancetype)initWithUploadTask:(NSURLSessionUploadTask *)uploadTask;
@end
