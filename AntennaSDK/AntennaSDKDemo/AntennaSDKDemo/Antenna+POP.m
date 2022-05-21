//
//  Antenna+POP.m
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/14.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import "Antenna+POP.h"

@implementation Antenna (POP)

//- (void)trackEvent:(NSString *)event content:(NSDictionary *)content {
    /**
     
     EventPayload *ep = [[EventPayload alloc] init];
     ep.event = event;
     ep.content = [eventContent copy];
     ep.ss = [POPSessionManager sharedInstance].sessionSource;
     ep.token = [POPConfigurationCenter loginToken];
     ep.uuid = [POPConfigurationCenter uuid];
     ep.deviceId = [POPConfigurationCenter idfv];
     radioWaveObject.ep = ep;
     
     radioWaveObject.uuid = [POPConfigurationCenter idfv] ?: @"";
     radioWaveObject.userid = [POPConfigurationCenter userId] ?: @"";
     radioWaveObject.city = [POPConfigurationCenter currentCity] ?: @"";
     radioWaveObject.ts = [NSString stringWithFormat:@"%llu", [self getCurrentTimestamp]];
     radioWaveObject.dt = kPOPEventTitle;
     radioWaveObject.refer = kPOPEventRefer;
     radioWaveObject.pkgID = [[[[NSBundle mainBundle] bundleIdentifier] componentsSeparatedByString:@"."] lastObject] ?: @"";
     
     if (!radioWaveObject.city || radioWaveObject.city.length == 0) {
     radioWaveObject.city = kPOPEventCity;
     }
     
     radioWaveObject.channel = [POPConfigurationCenter channel];
     radioWaveObject.rukou = [POPConfigurationCenter webAdPlace];
     
     */
    
    
//    POPModule *module = [self.moduleManager moduleForModuleId:self.traces.lastObject];
//    
//    [AntennaSharedInstance trackEvent:event
//                              content:content
//                           loginToken:[POPConfigurationCenter loginToken]
//                        sessionSource:[POPSessionManager sharedInstance].sessionSource
//                                 uuid:[POPConfigurationCenter uuid]
//                             deviceId:[POPConfigurationCenter idfv]
//                                 idfv:[POPConfigurationCenter idfv] ?: @""
//                               userid:[POPConfigurationCenter userId] ?: @""
//                                 city:[POPConfigurationCenter currentCity] ?: @""
//                              channel:[POPConfigurationCenter channel]
//                                rukou:[POPConfigurationCenter webAdPlace]
//                           moduleName:module.name];
//}
@end
