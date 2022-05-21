//
//  AntennaArchiverChannel.m
//  Brooks
//
//  Created by Brooks on 9/10/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//

#import "AntennaArchiverChannel.h"
#import "LKDocumentDirectoryArchiver.h"
#import "AntennaRadioWaveObject.h"
#import "Antenna.h"

static dispatch_queue_t antenna_archiver_queue() {
    static dispatch_queue_t antenna_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        antenna_creation_queue = dispatch_queue_create("com.renrenche.renrenche.antenna.archiver", DISPATCH_QUEUE_SERIAL);
    });

    return antenna_creation_queue;
}

@interface AntennaArchiverChannel ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSMutableArray <RadioWave> *radioWaves;

@end

@implementation AntennaArchiverChannel

- (id)initWithFilePath:(NSString *)path {
    if (self = [super init]) {
        _path = path;
    }

    return self;
}

- (void)emitRadioWave:(id <RadioWave>)radioWave {

    if (!radioWave) return;

    NSMutableArray <RadioWave> *radioWaves = [self unarchiveRadioWaves];

    dispatch_sync(antenna_archiver_queue(), ^{
        if (![radioWaves containsObject:radioWave]) {
            [radioWaves addObject:radioWave];

            if ([Antenna sharedInstance].debug) {
                NSLog(@"remain radioWaves count: %zd", radioWaves.count);
                NSLog(@"emit radioWave: %@", radioWave);
            }
        }
    });
}

- (id <RadioWave>)absorbRadioWave {
    NSMutableArray <RadioWave> *radioWaves = [self unarchiveRadioWaves];

    if (!radioWaves || radioWaves.count == 0)
        return nil;

    id <RadioWave> radioWave = radioWaves.firstObject;

    if (!radioWave) return nil;

    dispatch_sync(antenna_archiver_queue(), ^{
        if ([radioWaves containsObject:radioWave]) {
            [radioWaves removeObject:radioWave];

            if ([Antenna sharedInstance].debug) {
                NSLog(@"remain radioWaves count: %zd", radioWaves.count);
                NSLog(@"pop radioWave: %@", radioWave);
            }
        }
    });

    return radioWave;
}

- (void)archiveRadioWaves {
    if (!_path || _path.length == 0) return;

    NSMutableArray <RadioWave> *radioWaves = [self unarchiveRadioWaves];

    dispatch_sync(antenna_archiver_queue(), ^{
        if (radioWaves) {
            [LKDocumentDirectoryArchiver archiveRootObject:radioWaves forKey:_path];

            if ([Antenna sharedInstance].debug) {
                NSLog(@"archive radioWaves count: %zd", radioWaves.count);
            }
        }
    });
}

- (NSMutableArray <RadioWave> *)unarchiveRadioWaves {
    if (!_radioWaves) {
        if (!_path || _path.length == 0) {
            return (NSMutableArray <RadioWave> *) [[NSMutableArray alloc] init];
        }

        _radioWaves = (NSMutableArray <RadioWave> *) [NSMutableArray arrayWithArray:[LKDocumentDirectoryArchiver unarchiveObjectForKey:_path]];

        static NSUInteger kMaxRadioWavesCount = 200;
        if (_radioWaves && _radioWaves.count > kMaxRadioWavesCount) {
            [_radioWaves removeObjectsInRange:NSMakeRange(0, _radioWaves.count - kMaxRadioWavesCount)];
        }

        if ([Antenna sharedInstance].debug) {
            NSLog(@"unarchive radioWaves count: %zd", _radioWaves.count);
        }
    }

    return _radioWaves;
}

- (void)flushRadioWaves {
    if (!_radioWaves) {
        _radioWaves = (NSMutableArray <RadioWave> *) [[NSMutableArray alloc] init];
    }

    [LKDocumentDirectoryArchiver removeArchiveForKey:_path];
}

@end
