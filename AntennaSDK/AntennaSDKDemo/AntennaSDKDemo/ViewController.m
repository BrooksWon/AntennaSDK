//
//  ViewController.m
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/12.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import "ViewController.h"


#ifndef KLCPopup_class
#define KLCPopup_class NSClassFromString(@"KLCPopup")// 避免引入KLCPopup类,这样处理不好
#endif

#import "AntennaSDK.h"


@interface ViewController () <EventInterceptorProtocol>

@end

@implementation ViewController
- (IBAction)buttonAction:(id)sender {
//    [AntennaSharedInstance trackEvent:@"test-Event-1"];
//    
//    [AntennaSharedInstance trackEvent:@"test-Event-2" content:@{@"nameKey":@"Kong", @"ageKey":@20, @"sex":@"man"}];
    
    UIView *view = (UIView*)sender;
    view.pop_eventId = @"123";
    view.pop_eventName = @"test-Event-2";
    view.pop_eventContent = @{@"TODO":@"吃火锅 还是 日料呢?"};
    view.pop_experimentName = @"B";
    view.pop_experimentGroupName = @"B计划";
    view.pop_isLeafNode = NO;
//    
//    [AntennaSharedInstance trackEvent:@"test-Event-3"
//                              content:@{@"nameKey":@"Jack", @"ageKey":@50, @"sex":@"woman"}
//                           loginToken:@"loginToken"
//                        sessionSource:@"sessionSource"
//                                 uuid:@"uuid"
//                             deviceId:@"deviceId"
//                                 idfv:@"idfv"
//                               userid:@"userid"
//                                 city:@"上海"
//                              channel:@"channel"
//                                rukou:@"rukou"
//                           moduleName:@"IndexModule"];
//    
}

- (void)setTrackEvent {//A
    //vc
    self.pop_eventId = @"10086";
    self.pop_eventName = @"rootVC";
    self.pop_eventEnabled = YES;
    self.pop_eventContent = @{@"TODO":@"下午去看电影"};
    
    //view
    self.view.pop_eventId = @"123";
    self.view.pop_eventName = @"rootView";
    self.view.pop_eventContent = @{@"TODO":@"吃火锅 还是 日料呢?"};
    self.view.pop_experimentName = @"B";
    self.view.pop_experimentGroupName = @"B计划";
    self.view.pop_isLeafNode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSLog(@"%s, KLCPopup_class = %@", _cmd, KLCPopup_class);
    
    
//    [self setTrackEvent];
    
    //vc
    self.pop_eventId = @"10086";
    self.pop_eventName = @"rootVC";
    self.pop_eventEnabled = YES;
    self.pop_eventContent = @{@"TODO":@"下午去看电影"};
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}




@end
