// Antenna.m
// 
// Copyright (c) 2013 Mattt Thompson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Antenna.h"
#import "AntennaStreamChannel.h"
#import "AntennaHTTPChannel.h"
#import "AntennaLumerjackChannel.h"
#import "AntennaEventChannel.h"
#import "AntennaArchiverChannel.h"
#import "AntennaRadioWaveObject.h"
#import "AntennaConstEvent.h"
#import "AntennaUserDefaultKey.h"

//3rd
#import "NSString+MD5.h"
#import "MF_Base64Additions.h"
#import "SDVersion.h"

static NSTimeInterval const kSessionDuration = 5 * 60; // session 设定为 5 分钟, 指用户切到后台再切回来之间的时间间隔

@interface Antenna ()

@property (nonatomic, strong, readwrite) NSArray *channels; // 统计输出渠道
@property (nonatomic, strong, readwrite) NSMutableDictionary *defaultPayload; // 默认统计数据
@property (nonatomic, strong, readwrite) NSMutableDictionary *durations; // 用户访问页面
@property (nonatomic, strong, readwrite) NSMutableArray *traces; // 用户访问页面连续路径
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation Antenna

+ (instancetype)sharedInstance {
    static Antenna *_sharedAntenna = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAntenna = [[self alloc] init];
    });

    return _sharedAntenna;
}

- (id)init {
    self = [super init];
    if (self) {
        self.channels = [NSArray array];

        self.notificationCenter = [NSNotificationCenter defaultCenter];

        self.defaultPayload = [NSMutableDictionary dictionary];

        self.durations = [NSMutableDictionary dictionary];

        self.traces = [NSMutableArray array];

        [self.defaultPayload setValue:kEventVersion forKey:@"v"];
        [self.defaultPayload setValue:kEventHostname forKey:@"hn"];
        [self.defaultPayload setValue:kEventAccount forKey:@"ac"];
        [self.defaultPayload setValue:kEventSource forKey:@"source"];
        [self.defaultPayload setValue:[self getAppVersion] forKey:@"appv"];
        [self.defaultPayload setValue:[self getSystemVersion] forKey:@"osv"];
        [self.defaultPayload setValue:[self getModelName] forKey:@"model"];
        [self.defaultPayload setValue:kEventIMEI forKey:@"imei"];
    }

    return self;
}

- (void)startWithConfigure:(AntennaConfig *)config {
    NSMutableDictionary *defaultPayload = [Antenna sharedInstance].defaultPayload.mutableCopy;
    
    [defaultPayload setValue:config.eventVersion ?:kEventVersion forKey:@"v"];
    [defaultPayload setValue:config.eventHostname ?:kEventHostname forKey:@"hn"];
    [defaultPayload setValue:config.ac ?:kEventAccount forKey:@"ac"];
    [defaultPayload setValue:config.eventSource ?:kEventSource forKey:@"source"];
    [defaultPayload setValue:config.eventIMEI ?:kEventIMEI forKey:@"imei"];
    
    [Antenna sharedInstance].defaultPayload = defaultPayload;
}

+ (AFHTTPSessionManager *)httpSessionManager {
    if (![Antenna sharedInstance].sessionManager) {
        [Antenna sharedInstance].sessionManager = [AFHTTPSessionManager manager];
    }
    return [Antenna sharedInstance].sessionManager;
}

#pragma mark - Channel

- (void)addArchiverChannelWithFilePath:(NSString *)path {
    AntennaArchiverChannel *channel = [[AntennaArchiverChannel alloc] initWithFilePath:path];
    [self addChannel:channel];
}

- (void)addLumberjackChannel {
    AntennaLumerjackChannel *channel = [[AntennaLumerjackChannel alloc] init];
    [self addChannel:channel];
}

- (void)addEventChannel {
    AntennaEventChannel *channel = [[AntennaEventChannel alloc] init];
    [self addChannel:channel];
}

- (void)addChannelWithURL:(NSURL *)URL method:(NSString *)method {
    AntennaHTTPChannel *channel = [[AntennaHTTPChannel alloc] initWithURL:URL method:method];
    [self addChannel:channel];
}

- (void)addChannelWithFilePath:(NSString *)path {
    [self addChannelWithOutputStream:[NSOutputStream outputStreamToFileAtPath:path append:YES]];
}

- (void)addChannelWithOutputStream:(NSOutputStream *)outputStream {
    AntennaStreamChannel *channel = [[AntennaStreamChannel alloc] initWithOutputStream:outputStream];
    [self addChannel:channel];
}

- (void)addChannel:(id <AntennaChannel>)channel {
    self.channels = [self.channels arrayByAddingObject:channel];
}

- (void)removeChannel:(id <AntennaChannel>)channel {
    NSMutableArray *mutableChannels = [NSMutableArray arrayWithArray:self.channels];
    if ([channel respondsToSelector:@selector(prepareForRemoval)]) {
        [channel prepareForRemoval];
    }
    [mutableChannels removeObject:channel];
    self.channels = [NSArray arrayWithArray:mutableChannels];
}

- (void)removeAllChannels {
    [self.channels enumerateObjectsUsingBlock:^(id channel, __unused NSUInteger idx, __unused BOOL *stop) {
        if ([channel respondsToSelector:@selector(prepareForRemoval)]) {
            [channel prepareForRemoval];
        }
    }];

    self.channels = [NSArray array];
}

#pragma mark - session

/**
 * 手动 Session 管理实现
 * 参考 https://docs.localytics.com/dev/ios.html#alternative-initialization-objc-ios
 */
- (void)openSession {
    NSLog(@"method openSession called");

    NSDate *closeSessionDate = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyCloseSessionDate];
    if (closeSessionDate) {
        // 如果 Session 超过 5 分钟,
        if (closeSessionDate.timeIntervalSinceNow < - kSessionDuration) {
            [self.defaultPayload setValue:[self getSessionId] forKey:@"sid"];
        }
    } else {
        if (![self.defaultPayload valueForKey:@"sid"]) {
            [self.defaultPayload setValue:[self getSessionId] forKey:@"sid"];
        }
    }

    NSLog(@"session duration: %f", closeSessionDate.timeIntervalSinceNow);
}

- (void)closeSession {
    NSLog(@"method closeSession called");

    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kUserDefaultKeyCloseSessionDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearSession {
    NSLog(@"method clearSession called");

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultKeyCloseSessionDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - track event

- (void)trackEvent:(NSString *)event {
    [self trackEvent:event content:nil];
}

- (void)trackEvent:(NSString *)event content:(NSDictionary *)content {
    [self trackEvent:event
             content:content
          loginToken:nil
       sessionSource:nil
                uuid:nil
            deviceId:nil
                idfv:nil
              userid:nil
                city:nil
             channel:nil
               rukou:nil
          moduleName:nil];
}

- (void)trackEvent:(NSString *)event
           content:(NSDictionary *)content
        loginToken:(NSString *)loginToken
     sessionSource:(NSString *)sessionSource
              uuid:(NSString *)uuid
          deviceId:(NSString *)deviceId
              idfv:(NSString *)idfv
            userid:(NSString *)userid
              city:(NSString *)city
           channel:(NSString *)channel
             rukou:(NSString *)rukou
        moduleName:(NSString *)moduleName

{
    if (!event) {
        return;
    }

    NSMutableDictionary *eventContent = [NSMutableDictionary dictionaryWithDictionary:[content copy]];
    
    if (moduleName && [moduleName isKindOfClass:[NSString class]]) {
        eventContent[kEventKeyLastPageName] = moduleName.copy;
    }

    AntennaRadioWaveObject *radioWaveObject = [[AntennaRadioWaveObject alloc] init];

    [self.defaultPayload enumerateKeysAndObjectsUsingBlock:^(id key, id obj, __unused BOOL *stop) {
        if (obj && ![radioWaveObject valueForKey:key]) {
            [radioWaveObject setValue:obj forKey:key];
        }
    }];

    EventPayload *ep = [[EventPayload alloc] init];
    
    ep.event      = event;
    ep.content    = [eventContent copy];
    ep.ss         = sessionSource;
    ep.loginToken = loginToken;
    ep.uuid       = uuid;
    ep.deviceId   = deviceId;
    
    radioWaveObject.ep      = ep;
    radioWaveObject.uuid    = idfv ?: @"";
    radioWaveObject.userid  = userid ?: @"";
    radioWaveObject.city    = city ?: kEventCity;
    radioWaveObject.ts      = [NSString stringWithFormat:@"%llu", [self getCurrentTimestamp]];
    radioWaveObject.dt      = kEventTitle;
    radioWaveObject.refer   = kEventRefer;
    radioWaveObject.pkgID   = [[[[NSBundle mainBundle] bundleIdentifier] componentsSeparatedByString:@"."] lastObject] ?: @"";
    radioWaveObject.channel = channel;
    radioWaveObject.rukou   = rukou;

    // 如果 page_view 事件, 则 u 参数传入 page_id
    radioWaveObject.u       = radioWaveObject.ep.content[kEventKeyPageId] ?: @"";
    radioWaveObject.crc     = [self getCRCWithRadioWave:radioWaveObject];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-selector-match"
#pragma clang diagnostic ignored "-Wgnu"
    [self.channels enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id <AntennaChannel> channel, __unused NSUInteger idx, __unused BOOL *stop) {
        dispatch_sync(antenna_creation_queue(), ^{
            [channel emitRadioWave:radioWaveObject];
        });
    }];
#pragma clang diagnostic pop

}

- (void)beginEvent:(NSString *)event content:(NSDictionary *)content {
    if (!event) {
        return;
    }

    [self.durations setValue:[NSNumber numberWithLongLong:[self getCurrentTimestamp]] forKey:event];

    NSMutableDictionary *mutablePayload = [NSMutableDictionary dictionaryWithDictionary:content];
    [mutablePayload setValue:@YES forKey:kEventBeginPageView];
    [mutablePayload setValue:event forKey:kEventKeyPageId];

    if (self.traces.lastObject) {
        [mutablePayload setValue:self.traces.lastObject forKey:kEventReferPageView];
    }

    [self trackEvent:kEventIdPageView content:[mutablePayload copy]]; // 要求统一 PV 统计发送规则, 统一在 Begin 阶段发送 event:pageview
}

- (void)endEvent:(NSString *)event content:(NSDictionary *)content {
    long long start = 0;

    if (!event || !(start = [[self.durations valueForKey:event] longLongValue])) {
        return;
    }

    [self.durations removeObjectForKey:event];

    long long end = [self getCurrentTimestamp];
    double duration = (double)(end - start);

    NSMutableDictionary *mutablePayload = [NSMutableDictionary dictionaryWithDictionary:content];
    [mutablePayload setValue:@YES forKey:kEventEndPageView];
    [mutablePayload setValue:event forKey:kEventKeyPageId];
    [mutablePayload setValue:@(duration) forKey:@"duration"];

    if (self.traces.lastObject) {
        [mutablePayload setValue:self.traces.lastObject forKey:kEventReferPageView];
    }
    [self.traces addObject:event];

    [self trackEvent:kEventIdPageView content:[mutablePayload copy]];
}

static dispatch_queue_t antenna_creation_queue() {
    static dispatch_queue_t antenna_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        antenna_creation_queue = dispatch_queue_create("com.Brooks.Brooks.antenna.creation", DISPATCH_QUEUE_SERIAL);
    });

    return antenna_creation_queue;
}

#pragma mark - utils

- (NSString *)getAppVersion {
#ifdef DEBUG
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByAppendingString:@"-test"];
#else
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
#endif
}

- (NSString *)getSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)getModelName {
    return [SDVersion deviceNameString];
}

/**
 * SessionId 产生条件: Base64(idfv + '_' + timestamp)
 */
- (NSString *)getSessionId {
    NSLog(@"method getSessionId called");

    NSString *currentTime = [[NSString alloc] initWithFormat:@"%llu", [self getCurrentTimestamp]];

    return [[NSString stringWithFormat:@"%@_%@", [[UIDevice currentDevice].identifierForVendor UUIDString], currentTime] base64String];
}

- (long long)getCurrentTimestamp {
    return (long long) round([[NSDate date] timeIntervalSince1970]);
}

- (NSString *)getCRCWithRadioWave:(AntennaRadioWaveObject *)radioWave {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[radioWave toDictionary]];
    [dictionary removeObjectForKey:@"crc"];

    NSArray *keys = [dictionary allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [a compare:b];
    }];

    NSMutableArray *queries = [[NSMutableArray alloc] init];
    [sortedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [queries addObject:[NSString stringWithFormat:@"%@=%@", key, dictionary[key]]];
    }];

    NSString *queryString = [queries componentsJoinedByString:@"&"];

    return [queryString MD5Digest];
}

//- (void)prepareForRemoval {
//    [self stopLoggingAllNotifications];
//}

//- (void)startLoggingApplicationLifecycleNotifications {
//    NSArray *names = [NSArray arrayWithObjects:UIApplicationDidFinishLaunchingNotification, UIApplicationDidEnterBackgroundNotification, UIApplicationDidBecomeActiveNotification, UIApplicationDidReceiveMemoryWarningNotification, nil];
//    for (NSString *name in names) {
//        [self startLoggingNotificationName:name];
//    }
//}
//
//- (void)startLoggingNotificationName:(NSString *)name {
//    [self startLoggingNotificationName:name object:nil];
//}
//
//- (void)startLoggingNotificationName:(NSString *)name
//                              object:(id)object
//{
//    __weak __typeof(self)weakSelf = self;
//    [self startLoggingNotificationName:name object:object constructingPayLoadFromBlock:^NSDictionary *(NSNotification *notification) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//
//        NSMutableDictionary *mutablePayload = [strongSelf.defaultPayload mutableCopy];
//        if (notification.userInfo) {
//            [notification.userInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, __unused BOOL *stop) {
//                if (obj && key) {
//                    [mutablePayload setObject:obj forKey:key];
//                }
//            }];
//        }
//        [mutablePayload setObject:name forKey:@"notification"];
//
//        return mutablePayload;
//    }];
//}
//
//- (void)startLoggingNotificationName:(NSString *)name
//                              object:(id)object
//        constructingPayLoadFromBlock:(NSDictionary * (^)(NSNotification *notification))block
//{
//    __weak __typeof(self)weakSelf = self;
//    [self.notificationCenter addObserverForName:name object:object queue:self.operationQueue usingBlock:^(NSNotification *notification) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        NSDictionary *payload = nil;
//        if (block) {
//            payload = block(notification);
//        }
//
//        [strongSelf log:payload];
//    }];
//}

@end
