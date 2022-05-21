//
//  POPAspect.m
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/14.
//  Copyright © 2018年 Brooks. All rights reserved.
//

//#import "POPAspect.h"
//#import "AntennaSDK.h"
//#import "POPModuleManager.h"
//#import "Aspects.h"
//
//@interface POPAspect ()
//
//
//@end

//@implementation POPAspect

//+ (POPAspect *)sharedInstance {
//    static dispatch_once_t once;
//    static POPAspect *shareInstance;
//    dispatch_once(&once, ^{
//        shareInstance = [[self alloc] init];
//    });
//    
//    return shareInstance;
//}
//
//+ (void)configHookSelectors {
//    [[POPAspect sharedInstance] addHookViewWillAppear];
//    [EventInterceptor configHookSelectors];
//}
//
//// 为UIViewController 提前前注册 pop_eventName
//- (void)addHookViewWillAppear {
//    NSError *error = nil;
//
//    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore
//                               usingBlock:^(id <AspectInfo> aspectInfo, BOOL animated) {
//                                   if ([aspectInfo.instance isKindOfClass:[UIViewController class]]) {
//                                       UIViewController *viewController = (UIViewController *)aspectInfo.instance;
//                                       if (!viewController.pop_eventEnabled) {
//                                           return;
//                                       }
//                                       
//                                       NSString *moduleId = viewController.pop_eventId;
//                                       if (moduleId && moduleId.length > 0) {
//                                           
//                                           POPModule *module = [[POPModuleManager sharedInstance] moduleForModuleId:moduleId];
//                                           
//                                           // 赋值 eventName, 为了不依赖 POPModule 模块而能够获取 eventName.
//                                           // 并不是一个特别好的实现方式, 如其他更优雅的解决方案, 请提交 MR.
//                                           viewController.pop_eventName = viewController.pop_eventName ?: module.name ?:@"";
//                                       } else {
//                                           DDLogWarn(@"moduleId of %@ is nil", viewController);
//                                       }
//                                   }
//                               } error:&error];
//    
//    if (error) {
//        DDLogError(@"addHookSelectors fail.\r\nerror: %@", error);
//    }
//}

//@end

