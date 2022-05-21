//
//  AntennaConfig.m
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/16.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import "AntennaConfig.h"
#import "AntennaConstEvent.h"

@implementation AntennaConfig

@synthesize ac = _ac;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AntennaConfig *config = nil;
    if (!config) {
        dispatch_once(&onceToken, ^{
            config = [[self alloc] init];
        });
    }
    
    return config;
}

- (void)setAc:(NSString *)ac {
    // 如果ac入参错误,直接crash吐出错误给业务rd看
    NSAssert(ac && [ac isKindOfClass:[NSString class]] && ac.length>0, [NSString stringWithFormat:@"ac 设置错误,请仔细检查!"]);
    _ac = ac;
}

- (NSString *)ac {
    return _ac;
}

@end
