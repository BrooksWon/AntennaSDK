//
//  AntennaStreamChannel.m
//  Brooks
//
//  Created by Brooks on 9/9/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//

#import "AntennaStreamChannel.h"
#import "AntennaRadioWaveObject.h"


@interface AntennaStreamChannel ()

@property (nonatomic, strong, readwrite) NSOutputStream *outputStream;

@end

@implementation AntennaStreamChannel

- (id)initWithOutputStream:(NSOutputStream *)outputStream {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.outputStream = outputStream;
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.outputStream open];

    return self;
}

#pragma mark - AntennaChannel

- (void)emitRadioWave:(id <RadioWave>)radioWave {
    NSData *data = [[radioWave description] dataUsingEncoding:NSUTF8StringEncoding];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)prepareForRemoval {
    [self.outputStream close];
}

@end
