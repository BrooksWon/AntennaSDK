//
//  UIViewController+Log.m
//  Brooks
//
//  Created by Brooks on 9/14/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//

#import "UIViewController+Log.h"

#import <objc/runtime.h>

#define kUIViewControllerRRCEventEnabled "UIViewController.pop_eventEnabled"
#define kUIViewControllerRRCEventId "UIViewController.pop_eventId"
#define kUIViewControllerRRCEventName "UIViewController.pop_eventName"
#define kUIViewControllerRRCEventContent "UIViewController.pop_eventContent"

@implementation UIViewController (Log)

@dynamic pop_eventEnabled;
@dynamic pop_eventId;
@dynamic pop_eventName;
@dynamic pop_eventContent;

// pop_eventEnabled
- (BOOL)pop_eventEnabled {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewControllerRRCEventEnabled);
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *) obj).boolValue;
    }

    return YES;
}

- (void)setPop_eventEnabled:(BOOL)pop_eventEnabled {
    objc_setAssociatedObject(self, kUIViewControllerRRCEventEnabled, @(pop_eventEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// pop_eventId
- (NSString *)pop_eventId {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewControllerRRCEventId);
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *) obj;
    }

    return nil;
}

- (void)setPop_eventId:(NSString *)pop_eventId {
    objc_setAssociatedObject(self, kUIViewControllerRRCEventId, pop_eventId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// pop_eventName
- (NSString *)pop_eventName {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewControllerRRCEventName);
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *) obj;
    }
    return nil;
}

- (void)setPop_eventName:(NSString *)pop_eventName {
    objc_setAssociatedObject(self, kUIViewControllerRRCEventName, pop_eventName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// pop_eventContent
- (NSDictionary *)pop_eventContent {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewControllerRRCEventContent);
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *) obj;
    }

    return nil;
}

- (void)setPop_eventContent:(NSDictionary *)pop_eventContent {
    objc_setAssociatedObject(self, kUIViewControllerRRCEventContent, pop_eventContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
