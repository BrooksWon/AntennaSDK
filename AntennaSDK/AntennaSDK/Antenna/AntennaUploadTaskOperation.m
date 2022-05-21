//
//  AntennaUploadTaskOperation.m
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/14.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import "AntennaUploadTaskOperation.h"

@interface AntennaUploadTaskOperation ()

@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;

@end

@implementation AntennaUploadTaskOperation

- (instancetype)initWithUploadTask:(NSURLSessionUploadTask *)uploadTask {
    self = [super init];
    if (self) {
        _uploadTask = uploadTask;
    }
    
    return self;
}

- (void)main {
    if (self.uploadTask) {
        [self.uploadTask resume];
    }
}

- (void)cancel {
    if (self.uploadTask) {
        [self.uploadTask cancel];
    }
}

@end

