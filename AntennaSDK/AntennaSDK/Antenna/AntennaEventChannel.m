//
//  AntennaEventChannel.m
//  Brooks
//
//  Created by Brooks on 16/7/25.
//  Copyright © 2016年 Brooks. All rights reserved.
//

#import "AntennaEventChannel.h"
#import "AntennaRadioWaveObject.h"
#import "Antenna.h"
#import "AntennaConstNotification.h"

@implementation AntennaEventChannel

- (void)emitRadioWave:(AntennaRadioWaveObject *)radioWave {

#if defined(DEBUG) || defined(INHOUSE)

    NSMutableDictionary *newEvent = [NSMutableDictionary dictionary];
    if (radioWave.ep.event) {
        [newEvent setObject:radioWave.ep.event forKey:@"event"];
        if (radioWave.ep.content) {
            [newEvent setObject:radioWave.ep.content forKey:@"content"];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEventChannel object:newEvent];
        });
    }

#endif
}

@end
