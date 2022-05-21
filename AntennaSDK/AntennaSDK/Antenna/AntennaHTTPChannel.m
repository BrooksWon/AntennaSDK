//
//  AntennaHTTPChannel.m
//  Brooks
//
//  Created by Brooks on 9/9/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//

#import "AntennaUploadTaskOperation.h"
#import "AntennaHTTPChannel.h"
#import "AntennaRadioWaveObject.h"
#import "AntennaArchiverChannel.h"
#import "AntennaConstEvent.h"
#import "Antenna.h"
#import "GZIP.h"

#define kArchiverFilePath @"RadioWaves"
#define kLoopTimerInterval 1.f

@interface AntennaHTTPChannel ()

@property (nonatomic, strong, readwrite) NSURL *URL;
@property (nonatomic, copy, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *requestOperationManager;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSTimer *loopTimer;
@property (nonatomic, strong) NSTimer *archiveLoopTimer;
@property (nonatomic, assign) BOOL requestFailure;

@end

@implementation AntennaHTTPChannel

- (id)initWithURL:(NSURL *)url method:(NSString *)method {
    self = [super init];
    if (!self) {
        return nil;
    }

    _URL = url;
    _method = method;
    _requestOperationManager = [Antenna httpSessionManager];
    _operationQueue = _requestOperationManager.operationQueue;
    _operationQueue.maxConcurrentOperationCount = 3;
    _archiverChannel = [[AntennaArchiverChannel alloc] initWithFilePath:kArchiverFilePath];
    _requestFailure = NO;

    // 定期持久化内存数据, 因为存储很耗性能
    _archiveLoopTimer = [NSTimer scheduledTimerWithTimeInterval:30.f
                                                  target:self.archiverChannel
                                                selector:@selector(archiveRadioWaves)
                                                userInfo:nil
                                                 repeats:YES];
    [_archiveLoopTimer fire];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeNetworkReachability:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self.archiverChannel selector:@selector(archiveRadioWaves) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.archiverChannel selector:@selector(archiveRadioWaves) name:UIApplicationWillTerminateNotification object:nil];

    return self;
}

// 无网络情况下暂不上报, 保存到Archiver
- (void)didChangeNetworkReachability:(NSNotification *)notification {
    AFNetworkReachabilityStatus status = [(NSNumber *)notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] intValue];
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self.operationQueue setSuspended:NO];

            _loopTimer = [NSTimer scheduledTimerWithTimeInterval:kLoopTimerInterval
                                                          target:self
                                                        selector:@selector(resumeRadioWavesInArchiverChannel)
                                                        userInfo:nil
                                                         repeats:YES];

            if ([Antenna sharedInstance].debug) {
                NSLog(@"resume radioWave started");
            }
            break;
        case AFNetworkReachabilityStatusNotReachable:
        default:
            [self.operationQueue setSuspended:YES];
            break;
    }
}

#pragma mark - AntennaChannel

- (void)emitRadioWave:(AntennaRadioWaveObject *)radioWave {
    if ([self exclusiveRadioWave:radioWave]) return;

    if (self.operationQueue.suspended) {
        [self.archiverChannel emitRadioWave:radioWave];
        return;
    }

    NSMutableURLRequest *mutableRequest = [self.requestOperationManager.requestSerializer requestWithMethod:self.method
                                                                                           URLString:[self.URL absoluteString]
                                                                                          parameters:[radioWave toDictionary]
                                                                                               error:nil];

    NSData *compressedData = [mutableRequest.HTTPBody gzippedData];

    if (compressedData) {
        [mutableRequest setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        [mutableRequest setHTTPBody:compressedData];
    }

    NSURLSessionUploadTask *uploadTask = [self.requestOperationManager
        uploadTaskWithRequest:mutableRequest
                     fromData:compressedData
                     progress:nil
            completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject,
                                NSError *_Nullable error) {
                if (!error) {
                    // 统计数据问题则丢弃统计
                    if (!responseObject[@"status"] || ![responseObject[@"status"] isEqual:@0]) {
                        if ([Antenna sharedInstance].debug) {
                            NSLog(@"radioWave emit response error: %@", responseObject);
                        }
                    }

                    _requestFailure = NO;
                } else {
                    if ([Antenna sharedInstance].debug) {
                        NSLog(@"radioWave emit request error: %@", error);
                    }

                    // 服务器问题则全部缓存, 且不轮询消费, 等到下次网络变化或者下次使用时再发起.
                    [_loopTimer invalidate];

                    // 如果之前都是正确的, 执行一次 archive, 如果之前也错误就跳过
                    if (!_requestFailure) {
                        [self.archiverChannel archiveRadioWaves];
                    }

                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        [self.archiverChannel emitRadioWave:radioWave];
                    });

                    _requestFailure = YES;
                }
            }];

    // AFHTTPSessionManager 无法管理Task请求队列，自定义添加
    AntennaUploadTaskOperation *uploadTaskOperation = [[AntennaUploadTaskOperation alloc] initWithUploadTask:uploadTask];
    [self.operationQueue addOperation:uploadTaskOperation];
}

- (BOOL)exclusiveRadioWave:(AntennaRadioWaveObject *)radioWave {

    // 1. 过滤掉友盟统计直接调用 beginEvent / endEvent 方法的请求
    if ([radioWave.ep.event isEqualToString:kEventIdPageView] &&
        ![radioWave.ep.content.allKeys containsObject:kEventKeyPageName]) {
        return YES;
    }

    // 2. 过滤掉 EndPageView 事件, 跟其他平台一致化处理
    if ([radioWave.ep.event isEqualToString:kEventIdPageView] &&
        [radioWave.ep.content.allKeys containsObject:kEventEndPageView]) {
        return YES;
    }

    return NO;
}

- (void)prepareForRemoval {
    [self.operationQueue cancelAllOperations];
}

- (void)resumeRadioWavesInArchiverChannel {
    if (self.operationQueue.suspended) return;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        id <RadioWave> radioWaveObject = [self.archiverChannel absorbRadioWave];

        if (!radioWaveObject) {
            if ([Antenna sharedInstance].debug) {
                NSLog(@"resume radioWave empty");
            }

            [_loopTimer invalidate];
            [self.archiverChannel archiveRadioWaves];
            return;
        }

        // 通过 HTTP 发送 radioWave
        [self emitRadioWave:radioWaveObject];

        if ([Antenna sharedInstance].debug) {
            NSLog(@"resume radioWave: %@", radioWaveObject);
        }
    });
}

@end
