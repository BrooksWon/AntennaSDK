//
//  AntennaStreamChannel.h
//  Brooks
//
//  Created by Brooks on 9/9/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//


#import "AntennaChannel.h"


@interface AntennaStreamChannel : AntennaChannel

- (id)initWithOutputStream:(NSOutputStream *)outputStream;

@end
