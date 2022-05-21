//
//  AntennaConstEvent.h
//  AntennaSDKDemo
//  常用统计常量
//  统计分析SDK内的常量都需要在此处集中定义
//
//  Created by Brooks on 2018/1/14.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#ifndef AntennaConstEvent_h
#define AntennaConstEvent_h

/**
 * 服务器地址
 */
#ifdef DEBUG
    #define kPOPEventURL @"http://123.57.40.11/index.php?c=userlog_collect&m=normal_collect"
#else
    #define kPOPEventURL @"http://log.Brooks.com/index.php?c=userlog_collect&m=normal_collect"
#endif

#define kPOPEventMethod @"POST"

/**
 * 常量表
 */

#define kEventVersion @"1.0"
#define kEventTitle @""
#define kEventHostname @""
#define kEventAccount @"POP-QYH11-2001"
#define kEventSource @"ios"
#define kEventIMEI @""
#define kEventCity @""
#define kEventRefer @""
#define kEventReferPageView @"refer_page_view"
#define kEventBeginPageView @"begin_page_view"
#define kEventEndPageView @"end_page_view"

#define kEventIdPageView  @"page_view" // add, wai 0, 可以去掉外部
#define kEventKeyPageName @"page_name"//add, wai n,不能删除
#define kEventKeyPageId @"page_id"//add, wai n,不能删除
#define kEventKeyLastPageName @"last_page_name"//add, wai 0, 可以去掉外部
#define kEventKeyPageContent @"page_content"//sdk,可以去掉外部
#define kEventKeyExperimentName @"experiment_name" // A/B Testing 实验名称 add, wai 0, 可以去掉外部
#define kEventKeyExperimentGroupName @"experiment_group_name" // A/B Testing 实验分组名称 add, wai 0, 可以去掉外部


#endif /* AntennaConstEvent_h */
