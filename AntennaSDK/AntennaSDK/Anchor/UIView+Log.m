//
//  UIView+Log.m
//  Brooks
//
//  Created by Brooks on 15/5/9.
//  Copyright (c) 2015年 Brooks. All rights reserved.
//

#import "UIView+Log.h"

#import <objc/runtime.h>


#define kUIViewRRCEventId "UIView.pop_eventId"
#define kUIViewRRCEventName "UIView.pop_eventName"
#define kUIViewRRCEventContent "UIView.pop_eventContent"
#define kUIViewRRCIsLeafNode "UIView.pop_isLeafNode"
#define kUIViewRRCIncludePageViewEvent "UIView.pop_includePageViewEvent"
#define kUIViewRRCHasSentPageViewEvent "UIView.pop_hasSentPageViewEvent"

@implementation UIView (Log)

@dynamic pop_eventId;
@dynamic pop_eventName;
@dynamic pop_eventContent;
@dynamic pop_isLeafNode;

// pop_eventId
- (NSString *)pop_eventId {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCEventId);
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *) obj;
    }

    return nil;
}

- (void)setPop_eventId:(NSString *)pop_eventId {
    objc_setAssociatedObject(self, kUIViewRRCEventId, pop_eventId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// pop_eventName
- (NSString *)pop_eventName {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCEventName);
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *) obj;
    }

    return nil;
}

- (void)setPop_eventName:(NSString *)pop_eventName {
    objc_setAssociatedObject(self, kUIViewRRCEventName, pop_eventName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// pop_eventContent
- (NSDictionary *)pop_eventContent {
    NSDictionary *obj = objc_getAssociatedObject(self, kUIViewRRCEventContent);
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *) obj;
    }

    return nil;
}

- (void)setPop_eventContent:(NSDictionary *)pop_eventContent {
    objc_setAssociatedObject(self, kUIViewRRCEventContent, pop_eventContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// pop_isLeafNode
- (BOOL)pop_isLeafNode {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCIsLeafNode);
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *) obj).boolValue;
    }

    return YES;
}

- (void)setPop_isLeafNode:(BOOL)pop_isLeafNode {
    objc_setAssociatedObject(self, kUIViewRRCIsLeafNode, [NSNumber numberWithBool:pop_isLeafNode], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// pop_includePageViewEvent
- (BOOL)pop_includePageViewEvent {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCIncludePageViewEvent);
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *) obj).boolValue;
    }

    return NO;
}

- (void)setPop_includePageViewEvent:(BOOL)pop_includePageViewEvent {
    objc_setAssociatedObject(self, kUIViewRRCIncludePageViewEvent, [NSNumber numberWithBool:pop_includePageViewEvent], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// pop_hasSentPageViewEvent
- (BOOL)pop_hasSentPageViewEvent {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCHasSentPageViewEvent);
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *) obj).boolValue;
    }

    return NO;
}

- (void)setPop_hasSentPageViewEvent:(BOOL)pop_hasSentPageViewEvent {
    objc_setAssociatedObject(self, kUIViewRRCHasSentPageViewEvent, [NSNumber numberWithBool:pop_hasSentPageViewEvent], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
