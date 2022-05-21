//
//  AntennaUMengChannel.h
//  Brooks
//
//  Created by Brooks on 9/12/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//



#import "AntennaChannel.h"


@interface AntennaUMengChannel : AntennaChannel

- (instancetype)initWithUMengAppKey:(NSString *)appKey channelId:(NSString *)channelId;

@end
