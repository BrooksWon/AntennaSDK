//
//  EventInterceptor.m
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/13.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventInterceptor.h"

#import "UIView+Log.h"
#import "UIViewController+Log.h"
#import "UIView+ABTesting.h"

//3rd
#import "Aspects.h"

#import "AntennaConstEvent.h"

#import "Antenna.h"

//#import "KLCPopup.h"
#define KLCPopup_class NSClassFromString(@"KLCPopup")// 避免引入KLCPopup类,这样处理不好


@interface EventInterceptor ()

@end

@implementation EventInterceptor

+ (EventInterceptor *)sharedInstance {
    static dispatch_once_t once;
    static EventInterceptor *shareInstance;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (void)configHookSelectors {
    [[EventInterceptor sharedInstance] addHookSelectors];
}

- (void)addHookSelectors {
    NSError *error = nil;
    
    [UITapGestureRecognizer aspect_hookSelector:@selector(touchesEnded:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet *touches, UIEvent *event) {
        if ([aspectInfo.instance isMemberOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *) aspectInfo.instance;
            if (tapGestureRecognizer.numberOfTapsRequired == tapGestureRecognizer.numberOfTouches &&
                tapGestureRecognizer.state != UIGestureRecognizerStateCancelled &&
                tapGestureRecognizer.state != UIGestureRecognizerStateFailed) {
                [self execute:tapGestureRecognizer.view];
            }
        }
    } error:&error];
    
    [UIScrollView aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet *touches, UIEvent *event) {
        UITouch *touch = [touches anyObject];
        
        // 处理 tableViewCell 点击事件
        UIView *eventView = touch.view;
        while (eventView) {
            if (([eventView isKindOfClass:[UITableViewCell class]] || [eventView isKindOfClass:[UICollectionViewCell class]]) && eventView.pop_eventId) {
                [self execute:eventView];
                return;
            }
            
            eventView = eventView.superview;
        }
        
        // 不太清楚下面逻辑，未免错误，暂时保留
        if (touch.view && [touch.gestureRecognizers count] == 0 && ![touch.view isKindOfClass:[UIImageView class]]) {
            [self execute:touch.view];
        }
    } error:&error];
    
    [UIControl aspect_hookSelector:@selector(endTrackingWithTouch:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> aspectInfo, UITouch *touch, UIEvent *event) {
        UIView *view = (UIView *) aspectInfo.instance;
        if (view) {
            [self execute:view];
        }
    } error:&error];
    
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter
                               usingBlock:^(id <AspectInfo> aspectInfo, BOOL animated) {
                                   if ([aspectInfo.instance isKindOfClass:[UIViewController class]]) {
                                       UIViewController *viewController = (UIViewController *)aspectInfo.instance;
                                       if (!viewController.pop_eventEnabled) {
                                           return;
                                       }
                                       
                                       NSString *moduleId = viewController.pop_eventId;
                                       if (moduleId && moduleId.length > 0) {
                                           NSMutableDictionary *eventContent = [NSMutableDictionary dictionaryWithDictionary:viewController.pop_eventContent];
                                           eventContent[kEventKeyPageId] = moduleId;
                                           
                                           eventContent[kEventKeyPageName] = viewController.pop_eventName ?: @"";
                                           
                                           viewController.pop_eventName = viewController.pop_eventName ?: @"";
                                           
                                           [[Antenna sharedInstance] beginEvent:moduleId content:eventContent];
                                       } else {
                                           NSLog(@"moduleId of %@ is nil", viewController);
                                       }
                                   }
                               } error:&error];
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter
                               usingBlock:^(id <AspectInfo> aspectInfo, BOOL animated) {
                                   if ([aspectInfo.instance isKindOfClass:[UIViewController class]]) {
                                       UIViewController *viewController = (UIViewController *)aspectInfo.instance;
                                       if (!viewController.pop_eventEnabled) {
                                           return;
                                       }
                                       
                                       NSString *moduleId = viewController.pop_eventId;
                                       if (moduleId && moduleId.length > 0) {
                                           NSMutableDictionary *eventContent = [NSMutableDictionary dictionaryWithDictionary:viewController.pop_eventContent];
                                           eventContent[kEventKeyPageId] = moduleId;
                                           
                                           eventContent[kEventKeyPageName] = viewController.pop_eventName ?: @"";
                                           
                                           [[Antenna sharedInstance] endEvent:moduleId content:eventContent];
                                       } else {
                                           NSLog(@"moduleId of %@ is nil", viewController);
                                       }
                                   }
                               } error:&error];
    
    // 以下俩方法配合处理视图展现
    [UIView aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [self includePageViewEvent:aspectInfo.instance];
    } error:&error];
    
    [UIView aspect_hookSelector:@selector(setHidden:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [self includePageViewEvent:aspectInfo.instance];
    } error:&error];
    
    if (error) {
        NSLog(@"addHookSelectors fail.\r\nerror: %@", error);
    }
}

- (void)includePageViewEvent:(UIView *)view {
    if (view && (view.frame.size.width > 1e-6 && view.frame.size.height > 1e-6) && !view.hidden && !view.pop_hasSentPageViewEvent && view.pop_includePageViewEvent && view.pop_eventId) {
        [self execute:view];
        view.pop_hasSentPageViewEvent = YES;
    }
}

- (void)execute:(UIView *)touchView {
    UIView *eventView = touchView;
    
    NSMutableArray *eventIds = [[NSMutableArray alloc] init];
    NSMutableDictionary *eventContents = [[NSMutableDictionary alloc] init];
    NSString *moduleId = nil;
    
    if (touchView.superview) {
        while (touchView) {
            if (![touchView isKindOfClass:KLCPopup_class]) { // 跳过 KLCPopup 通用弹窗所属的 UIView, 将其作为 UIViewController 使用
                if (touchView.pop_eventId) {
                    
                    if (touchView.pop_isLeafNode) {
                        [eventIds removeAllObjects];
                    }
                    
                    [eventIds insertObject:touchView.pop_eventId atIndex:0];
                }
                
                if (touchView.pop_eventContent) {
                    
                    if (touchView.pop_isLeafNode) {
                        [eventContents removeAllObjects];
                    }
                    
                    [eventContents addEntriesFromDictionary:touchView.pop_eventContent];
                }
            }
            
            // 只取第一次获得到的 ViewController 名称, 避免获取到容器 ViewController, 例如 UITabBarController, UINavigationController
            if (!moduleId || moduleId.length == 0) {
                if ([touchView.nextResponder isKindOfClass:[UIViewController class]]) {
                    UIViewController *touchViewController = (UIViewController *) touchView.nextResponder;
                    
                    // 针对 NavigationBar 按钮点击事件, 特殊处理
                    if ([touchViewController isKindOfClass:[UINavigationController class]]) {
                        touchViewController = [(UINavigationController *)touchViewController topViewController];
                    }
                    
                    moduleId = touchViewController.pop_eventId;
                    eventContents[kEventKeyPageId] = moduleId ?: @"";
                    
                    // 增加页面名称
                    eventContents[kEventKeyPageName] = touchViewController.pop_eventName ?: @"";
                    
                    // 增加页面级别统计参数配置, 例如列表页大小图模式, 详情页是否加新
                    if (touchViewController.pop_eventContent) {
                        eventContents[kEventKeyPageContent] = touchViewController.pop_eventContent;
                    }
                } else if ([touchView.nextResponder isKindOfClass:KLCPopup_class]) { // KLCPopup 实现是添加在 UIWindow 里, 不包含在任何 UIViewController
                    UIView *popup = (UIView *)touchView.nextResponder;
                    
                    moduleId = popup.pop_eventId;
                    eventContents[kEventKeyPageId] = moduleId ?: @"";
                    
                    // 增加页面名称
                    eventContents[kEventKeyPageName] = popup.pop_eventName ?: @"";
                    
                    // eventContent 直接添加到 eventContents 里, 而不添加到 PageContent 参数中
                    if (popup.pop_eventContent) {
                        [eventContents addEntriesFromDictionary:popup.pop_eventContent];
                        eventContents[kEventKeyPageContent] = popup.pop_eventContent;
                    }
                }
            }
            
            touchView = touchView.superview;
        }
    } else {
        if (touchView.pop_eventId) {
            [eventIds insertObject:touchView.pop_eventId atIndex:0];
        }
        
        if (touchView.pop_eventContent) {
            [eventContents addEntriesFromDictionary:touchView.pop_eventContent];
        }
    }
    
    // A/B Testing 分组添加
    if (!eventView.pop_experimentArchived) { // 需要发送统计
        if (eventView.pop_experimentStatus == 0) {
            eventContents[kEventKeyExperimentGroupName] = eventView.pop_experimentGroupName ?: @"";
            eventContents[kEventKeyExperimentName] = eventView.pop_experimentName ?: @"";
        } else { // 异常情况下
            eventContents[kEventKeyExperimentGroupName] = @"error";
            eventContents[kEventKeyExperimentName] = @"error";
        }
    }
    
    // Module 名称校验
    if (!moduleId || moduleId.length == 0) {
        NSLog(@"moduleId of %@ %@ is nil", eventView, touchView);
        
        return;
    }
    
    if (eventIds && [eventIds count] > 0) {
        [eventIds insertObject:moduleId atIndex:0];
        
        if (eventView.pop_includePageViewEvent && !eventView.pop_hasSentPageViewEvent) {
            [eventIds addObject:@"PageView"];
        }
        
        NSString *eventId = [eventIds componentsJoinedByString:@"_"];
        
        [[Antenna sharedInstance] trackEvent:eventId content:eventContents];
    }
}

@end

