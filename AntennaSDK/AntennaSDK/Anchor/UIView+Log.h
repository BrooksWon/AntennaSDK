//
//  UIView+Log.h
//  Brooks
//
//  Created by Brooks on 15/5/9.
//  Copyright (c) 2015年 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Log)

/**
 * 统计事件Id, 一旦添加 eventId, 就会被添加到统计事件
 */
@property (nonatomic, copy) NSString *pop_eventId;

/**
 * 统计事件名称, 填写中文名称
 */
@property (nonatomic, copy) NSString *pop_eventName;

/**
 * 统计事件附加属性
 */
@property (nonatomic, strong) NSDictionary *pop_eventContent;

/**
 * 是否作为统计子节点, 进而截断所有子节点统计
 */
@property (nonatomic, assign) BOOL pop_isLeafNode;

/**
 * 是否作为 PageView 类型事件进行统计（默认为NO）
 */
@property (nonatomic, assign) BOOL pop_includePageViewEvent;

/**
 * 与 pop_includePageViewEvent 属性关联，标识 PageView 事件类型的统计是否已经发送（默认为NO）
 */
@property (nonatomic, assign) BOOL pop_hasSentPageViewEvent;

@end
