//
//  UIView+ABTesting.m
//  Brooks
//
//  Created by Brooks on 16/5/13.
//  Copyright © 2016年 Brooks. All rights reserved.
//

#import "UIView+ABTesting.h"
#import <objc/runtime.h>

#define kUIViewRRCExperimentGroupName "UIView.pop_experimentGroupName"
#define kUIViewRRCExperimentName "UIView.pop_experimentName"
#define kUIViewRRCExperimentStatus "UIView.pop_experimentStatus"
#define kUIViewRRCExperimentArchived "UIView.pop_experimentArchived"

@implementation UIView (ABTesting)

@dynamic pop_experimentGroupName;
@dynamic pop_experimentName;
@dynamic pop_experimentStatus;
@dynamic pop_experimentArchived;

/**
 *  实验名称
 */
- (NSString *)pop_experimentName {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCExperimentName);
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *) obj;
    }

    return nil;
}

- (void)setPop_experimentName:(NSString *)pop_experimentName {
    objc_setAssociatedObject(self, kUIViewRRCExperimentName, pop_experimentName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  实验分组名称
 */
- (NSString *)pop_experimentGroupName {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCExperimentGroupName);
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *) obj;
    }

    return nil;
}

- (void)setPop_experimentGroupName:(NSString *)pop_experimentGroupName {
    objc_setAssociatedObject(self, kUIViewRRCExperimentGroupName, pop_experimentGroupName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  实验状态
 */
- (NSUInteger)pop_experimentStatus {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCExperimentStatus);
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *) obj).unsignedIntegerValue;
    }

    return 0;
}

- (void)setPop_experimentStatus:(NSUInteger)pop_experimentStatus {
    objc_setAssociatedObject(self, kUIViewRRCExperimentStatus, [NSNumber numberWithUnsignedInteger:pop_experimentStatus], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  实验归档
 */
- (BOOL)pop_experimentArchived {
    NSObject *obj = objc_getAssociatedObject(self, kUIViewRRCExperimentArchived);
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *) obj).boolValue;
    }

    return NO;
}

- (void)setPop_experimentArchived:(BOOL)pop_experimentArchived {
    objc_setAssociatedObject(self, kUIViewRRCExperimentArchived, [NSNumber numberWithBool:pop_experimentArchived], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
