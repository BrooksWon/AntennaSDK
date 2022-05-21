//
//  AntennaHTTPChannel.h
//  Brooks
//
//  Created by Brooks on 9/9/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//


#import "AFURLRequestSerialization.h"
#import "AntennaChannel.h"


@class AntennaArchiverChannel;


@interface AntennaHTTPChannel : AntennaChannel

- (id)initWithURL:(NSURL *)url method:(NSString *)method;

@property (nonatomic, strong, readwrite) AntennaArchiverChannel *archiverChannel;

@end
