//
//  AntennaConfig.h
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/16.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AntennaConfigInstance [AntennaConfig sharedInstance]
@interface AntennaConfig : NSObject
/** required:  ac string , default: POP-QYH11-2001 */
@property(nonatomic, copy) NSString *ac;
/** optional:  default: 1.0 */
@property(nonatomic, copy) NSString *eventVersion;
/** optional:  default: nil */
@property(nonatomic, copy) NSString *eventHostname;
/** optional:  default: ios */
@property(nonatomic, copy) NSString *eventSource;
/** optional:  default: nil */
@property(nonatomic, copy) NSString *eventIMEI;

+ (instancetype)sharedInstance;
@end
