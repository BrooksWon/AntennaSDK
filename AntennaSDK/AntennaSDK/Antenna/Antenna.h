// Antenna.h
// 
// Copyright (c) 2013 Mattt Thompson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"

#import "AntennaConfig.h"

@protocol AntennaChannel;


/**
 * Antenna objects asynchronously log notifications to subscribed channels, such as web services, files, or Core Data entities. Each logging message comes with global state information, including a unique identifier for the device, along with any additional data from the notification itself.
 */
@interface Antenna : NSObject

/**
 * The default payload to include in each logged message.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *defaultPayload;

/**
 * The notification center on which to observe notifications.
 */
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

/**
 * The currently active channels.
 */
@property (nonatomic, strong, readonly) NSArray *channels;

/**
 * The debug state to enable console log
 */
@property (nonatomic, assign) BOOL debug;

/**
 * The shared Antenna instance.
 */
+ (instancetype)sharedInstance;

/**
 * The Antenna config
 */
- (void)startWithConfigure:(AntennaConfig *)config;

#define AntennaSharedInstance [Antenna sharedInstance]


/**
 *  针对统计的AFHTTPSessionManager单例
 */
+ (AFHTTPSessionManager *)httpSessionManager;

///======================
/// @name Adding Channels
///======================

/**
 * Adds a new channel that logs messages to archiver.
 */
- (void)addArchiverChannelWithFilePath:(NSString *)path;

/**
 * Adds a new channel that logs messages to cocoa lumberjack debugger.
 */
- (void)addLumberjackChannel;

/**
 * Adds a new channel that event logs messages to user interface.
 */
- (void)addEventChannel;

/**
 * Adds a new channel that logs to the specified URL with a given HTTP method.
 */
- (void)addChannelWithURL:(NSURL *)URL method:(NSString *)method;

/**
 * Adds a new channel that logs messages to a file at the specified path.
 */
- (void)addChannelWithFilePath:(NSString *)path;

/**
 * Adds a new channel that logs messages to the specified output stream.
 */
- (void)addChannelWithOutputStream:(NSOutputStream *)outputStream;

/**
 * Adds the specified channel.
 *
 * @param channel The channel to add.
 */
- (void)addChannel:(id <AntennaChannel>)channel;

/**
 * Removes the specified channel, if present.
 *
 * @param channel The channel to remove.
 */
- (void)removeChannel:(id <AntennaChannel>)channel;

/**
 * Removes all channels.
 */
- (void)removeAllChannels;

/**
 * Open new session
 */
- (void)openSession;

/**
 * Close this session
 */
- (void)closeSession;

/**
 * Clear this session
 */
- (void)clearSession;

/**
 * Log the specified event
 */
- (void)trackEvent:(NSString *)event;

/**
 * Log the specified event and content.
 */
- (void)trackEvent:(NSString *)event content:(NSDictionary *)content;

#warning 新添加的,防止业务库引入 在外部给个适配器 POP类别 实现业务0侵入
/**
 * Log the specified event and content.
 */
- (void)trackEvent:(NSString *)event
           content:(NSDictionary *)content
        loginToken:(NSString *)loginToken
     sessionSource:(NSString *)sessionSource
              uuid:(NSString *)uuid
          deviceId:(NSString *)deviceId
              idfv:(NSString *)idfv
            userid:(NSString *)userid
              city:(NSString *)city
           channel:(NSString *)channel
             rukou:(NSString *)rukou
        moduleName:(NSString *)moduleName;

/**
 * Begin track the specified event and content, calculate durations automatically.
 */
- (void)beginEvent:(NSString *)event content:(NSDictionary *)content;

/**
 * End track the specified event and content, calculate durations automatically.
 */
- (void)endEvent:(NSString *)event content:(NSDictionary *)content;

@end

