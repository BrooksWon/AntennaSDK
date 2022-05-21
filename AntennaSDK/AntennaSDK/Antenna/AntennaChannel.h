//
//  AntennaChannel.h
//  Brooks
//
//  Created by Brooks on 9/9/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RadioWave;

/**
 * The AntennaChannel protocol defines the required methods for objects that can be added as channels by Antenna.
 */
@protocol AntennaChannel <NSObject>

@required

- (void)emitRadioWave:(id <RadioWave>)radioWave;

@optional

/**
 * Called before a channel is removed.
 *
 * @warning This method should never be called directly.
 */
- (void)prepareForRemoval;

@end


@interface AntennaChannel : NSObject <AntennaChannel>

@end
