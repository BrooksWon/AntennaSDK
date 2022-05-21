//
//  AntennaRadioWaveObject.h
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/12.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 接口标识
 */
@protocol RadioWave <NSObject>

- (NSDictionary *)toDictionary;

@end


/**
 * 承载事件内容
 */
@interface EventPayload : NSObject <RadioWave, NSCoding>

@property (nonatomic, strong) NSString *event; // 事件名称
@property (nonatomic, strong) NSDictionary *content; // 事件内容
@property (nonatomic, strong) NSString *ss; // sessionSource
@property (nonatomic, strong) NSString *loginToken; // loginToken
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *deviceId;

@end


/**
 * 承载事件对象
 */
@interface AntennaRadioWaveObject : NSObject <RadioWave, NSCoding>

@property (nonatomic, strong) NSString *v; // 版本号
@property (nonatomic, strong) NSString *hn; // 域
@property (nonatomic, strong) NSString *u; // 当前页面标识符
@property (nonatomic, strong) NSString *dt; // 页面标题
@property (nonatomic, strong) NSString *refer; // referrer
@property (nonatomic, strong) EventPayload *ep; // 事件标识符, 主要是event和content
@property (nonatomic, strong) NSString *ac; // 统计标识
@property (nonatomic, strong) NSString *ts; // 时间戳
@property (nonatomic, strong) NSString *sid; // session id
@property (nonatomic, strong) NSString *source; // 来源
@property (nonatomic, strong) NSString *uuid; // 用户唯一标识
@property (nonatomic, strong) NSString *userid; // 用户ID
@property (nonatomic, strong) NSString *appv; // app version
@property (nonatomic, strong) NSString *osv; // os version
@property (nonatomic, strong) NSString *model; // 机型
@property (nonatomic, strong) NSString *channel; // 渠道
@property (nonatomic, strong) NSString *rukou; // 广告位入口
@property (nonatomic, strong) NSString *imei; // imei
@property (nonatomic, strong) NSString *city; // 城市
@property (nonatomic, strong) NSString *crc; // 校验码
@property (nonatomic, strong) NSString *pkgID; // 包名
@property (nonatomic, strong) NSString *deviceID; // 设备标识

@end

