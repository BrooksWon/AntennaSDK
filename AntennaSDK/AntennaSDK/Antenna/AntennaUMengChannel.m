//
//  AntennaUMengChannel.m
//  Brooks
//
//  Created by Brooks on 9/12/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//


#import <UMMobClick/MobClick.h>

#import "AntennaUMengChannel.h"
#import "AntennaRadioWaveObject.h"
#import "Antenna.h"
#import "AntennaConstEvent.h"


@implementation AntennaUMengChannel

- (instancetype)initWithUMengAppKey:(NSString *)appKey channelId:(NSString *)channelId {
    
    // 如果appKey入参错误,直接crash吐出错误给业务rd看
    NSAssert(appKey && [appKey isKindOfClass:[NSString class]] && appKey.length>0, [NSString stringWithFormat:@"UM AppKey 设置错误,请仔细检查!"]);
    
    self = [super init];
    if (self) {
        UMConfigInstance.appKey = appKey;
        UMConfigInstance.ePolicy = BATCH;
        UMConfigInstance.channelId = channelId;
        [MobClick startWithConfigure:UMConfigInstance];
        
#if defined(DEBUG) || defined(INHOUSE)
        [MobClick setAppVersion:[NSString stringWithFormat:@"%@-test", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
#else
        [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
#endif
        [MobClick setEncryptEnabled:YES];
        [MobClick setLogEnabled:[Antenna sharedInstance].debug];
    }
    
    return self;
}

- (void)emitRadioWave:(AntennaRadioWaveObject *)radioWave {
    if ([radioWave.ep.content[kEventBeginPageView] isEqual:@YES]) {
        NSString *pageId = radioWave.ep.content[kEventKeyPageId];
        [MobClick beginLogPageView:pageId];
    } else if ([radioWave.ep.content[kEventEndPageView] isEqual:@YES]) {
        NSString *pageId = radioWave.ep.content[kEventKeyPageId];
        [MobClick endLogPageView:pageId];
    } else if ([radioWave.ep.content[kEventIdPageView] isEqual:@YES]) {
        NSString *pageId = radioWave.ep.content[kEventKeyPageId];
        [MobClick logPageView:pageId seconds:[radioWave.ep.content[@"duration"] intValue]];
    } else {
        [MobClick event:radioWave.ep.event];
    }
}

@end
