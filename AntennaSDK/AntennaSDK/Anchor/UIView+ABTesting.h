//
//  UIView+ABTesting.h
//  扩展UIView，用于A/B Testing。参加实验的view，需要设置两个属性。
//
//  Created by Brooks on 16/5/13.
//  Copyright © 2016年 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ABTesting)

/**
 *  A/B Testing 的实验名称。例如：experiment_detail_bookmark
 */
@property (nonatomic, copy) NSString *pop_experimentName;

/**
 *  A/B Testing 的实验分组名称。例如：A,B
 */
@property (nonatomic, copy) NSString *pop_experimentGroupName;

/**
 *  A/B Testing 的实验状态。0：正常；非0：不正常
 */
@property (nonatomic, assign) NSUInteger pop_experimentStatus;

/**
 *  A/B Testing 的实验是否归档。false：发送统计事件;true：不发送统计事件，表示该实验已经结束
 */
@property (nonatomic, assign) BOOL pop_experimentArchived;

@end
