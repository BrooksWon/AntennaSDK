//
//  AntennaSDKDemoTests.m
//  AntennaSDKDemoTests
//
//  Created by Brooks on 2018/1/12.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AntennaSDK.h"
#import "ViewController.h"
#import "Aspects.h"

@interface AntennaSDKDemoTests : XCTestCase
- (void)hookViewDidLoad;
@end

@implementation AntennaSDKDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [self hookViewDidLoad];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)test_trackEvent {
    [AntennaSharedInstance trackEvent:@"test-Event-1"];
}

- (void)test_trackEvent_content{
    [AntennaSharedInstance trackEvent:@"test-Event-2" content:@{@"nameKey":@"Kong", @"ageKey":@20, @"sex":@"man"}];
}

- (void)test_trackEvent_More{
    [AntennaSharedInstance trackEvent:@"test-Event-3"
                              content:@{@"nameKey":@"Jack", @"ageKey":@50, @"sex":@"woman"} loginToken:@"loginToken"
                        sessionSource:@"sessionSource"
                                 uuid:@"uuid"
                             deviceId:@"deviceId"
                                 idfv:@"idfv"
                               userid:@"userid"
                                 city:@"上海"
                              channel:@"channel"
                                rukou:@"rukou"
                           moduleName:@"IndexModule"];
}

- (void)testHookViewDidLoad_trackEvent {
    ViewController *vc = [[ViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    [vc buttonAction:nil];
}

- (void)hookViewDidLoad {
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id <AspectInfo> aspectInfo, BOOL animated){
        UIViewController *viewController = (UIViewController *)aspectInfo.instance;
        
        viewController.pop_eventName = viewController.pop_eventName ?: @"TestModels";
    } error:nil];
}

@end
