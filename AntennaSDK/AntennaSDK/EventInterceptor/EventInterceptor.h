//
//  EventInterceptor.h
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/13.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventInterceptorProtocol <NSObject>

@required

- (void)setTrackEvent;

@end

@interface EventInterceptor : NSObject

+ (void)configHookSelectors;

@end
