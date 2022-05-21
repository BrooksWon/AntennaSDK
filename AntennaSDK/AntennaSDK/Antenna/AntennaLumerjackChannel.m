//
//  AntennaLumerjackChannel.m
//  Brooks
//
//  Created by Brooks on 9/9/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//

#import "AntennaLumerjackChannel.h"
#import "Antenna.h"

@implementation AntennaLumerjackChannel

- (void)emitRadioWave:(id <RadioWave>)radioWave {
    if ([Antenna sharedInstance].debug) {
        NSLog(@"emit radioWave: %@", radioWave);
    }
}

@end
