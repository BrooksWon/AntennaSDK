//
//  UIViewController+Log.h
//  Brooks
//
//  Created by Brooks on 9/14/15.
//  Copyright (c) 2015 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (Log)

/**
 * 是否需要统计 PageView 事件, 默认值是 YES
 */
@property (nonatomic, assign) BOOL pop_eventEnabled;

/**
 * 统计事件ID, 填写英文标识
 */
@property (nonatomic, strong) NSString *pop_eventId;

/**
 * 统计事件名称, 填写中文名称
 */
@property (nonatomic, strong) NSString *pop_eventName;

/**
 * 统计事件附加属性
 */
@property (nonatomic, strong) NSDictionary *pop_eventContent;

@end
