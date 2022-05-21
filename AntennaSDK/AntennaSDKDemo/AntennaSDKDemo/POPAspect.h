//
//  POPAspect.h
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/14.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol POPAspectProtocol <NSObject>

@required

- (void)setTrackEvent;

@end

@interface POPAspect : NSObject

//+ (void)configHookSelectors;

@end
