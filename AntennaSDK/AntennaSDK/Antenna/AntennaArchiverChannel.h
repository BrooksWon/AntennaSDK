//
//  AntennaArchiverChannel.h
//  Brooks
//
//  Created by Brooks on 9/10/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//



#import "AntennaChannel.h"


@interface AntennaArchiverChannel : AntennaChannel

/**
 * 根据文件路径初始化
 */
- (id)initWithFilePath:(NSString *)path;

/**
 * 发送待发送的统计入栈
 */
- (void)emitRadioWave:(id <RadioWave>)radioWave;

/**
 * 弹出待发送的统计出栈
 */
- (id <RadioWave>)absorbRadioWave;

/**
 * 将 radioWaves 持久化
 */
- (void)archiveRadioWaves;


/**
 * 将 radioWaves 清空
 */
- (void)flushRadioWaves;

@end
