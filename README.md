# AntennaSDK

iOS 事件统计组件

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 8.0+, Objective-C


## Installation

`AntennaSDK` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'AntennaSDK'
```

or

To install the `AntennaSDK`, just drag and drop the .h and .m files into your project folder. Import them when you need it.

## Usage

import "AntennaSDK.h"

```
// 配置ac
AntennaConfig *config = AntennaConfigInstance;

config.ac = @"wangjianyu test ac @2018-1-16";

[AntennaSharedInstance startWithConfigure:config];

```

```
[AntennaSharedInstance trackEvent:@"test-Event-1"];
```

or

```
[AntennaSharedInstance trackEvent:@"test-Event-2" content:@{@"nameKey":@"Kong", @"ageKey":@20, @"sex":@"man"}];
```
or

```
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
```

## Notice
实现 `EventInterceptorProtocol`协议的 `setTrackEvent` 方法, 统一设置事件属性.

## 实现方案
一、实现思路
事件统计方案由三部分组成：事件埋点（UIView Category），事件拦截（EventInterceptor），事件分发（Antenna），完成从埋点注册，到触发，再到发送的整个过程。

二、事件埋点
通过给UIView添加Category（UIView＋Log）来实现自动埋点。UIView＋Log 实现默认埋点的属性配置，UIView＋ABTesting 实现参与A/B Testing 的属性配置。

1、默认埋点
（1）UIView扩展

UIView＋Log 中增加了四个属性，想进行事件统计上报的view只需要设置相关属性就可以完成后续上报过程。

pop_eventId：统计事件Id, 一旦添加 eventId, 就会被添加到统计事件。

pop_eventName：统计事件名称, 填写中文名称。

pop_eventContent：统计事件附加属性。

pop_isLeafNode：是否作为统计子节点, 进而截断所有子节点统计。

（2）统计规则
统计规则为：UIViewController_SuperView.eventId_ChildView.eventId。但是由于目前iOS架构使用Router跳转，所以规则有的为ModuleId_SuperView.eventId_ChildView.eventId。**规则主要为了支持下图中嵌套视图中都设置pop_eventId的情况，绝大多数为ModuleId_ChildView.eventId。**

（3）举例：

![](https://github.com/BrooksWon/AntennaSDK/blob/main/AntennaLevel.png)


默认规则统计ID为：ViewControllerA_ViewB_VIewC ;

ViewB的pop_isLeafNode＝YES：ViewControllerA_ViewB ；

2、A/B Testing 埋点
（1）UIView扩展
UIView+ABTesting 增加了两个属性，参加到实验的View只需要设置这两个属性就可以触发Adhoc的统计发送。

pop_experimentName：A/B Testing 的实验名称。

pop_experimentGroupName：A/B Testing 的实验分组名称。

三、事件拦截
事件拦截使用开源库Aspect，经过封装成EventInterceptor。

EventInterceptor类中包含EventInterceptorProtocol协议，所有需要添加统计的对象都需要实现此协议中的setTrackEvent方法，建议在其内部设置pop_eventId。

EventInterceptor内部hook事件响应链和UIViewController生命周期中的相关方法，来实现事件拦截。拦截成功后，针对视图层次，拼接事件ID。如果触发事件的View参与了A/B Testing 则在pop_eventContent 中添加相关实验信息。

检测事件ID有效性后，发送给事件分发系统。

三、事件分发
事件分发使用开源库Antenna作为模版，经过删减修改处理成自己使用的事件分发模块。

Antenna包括三部分：Antenna，对外统一接口；Channel，每个渠道都是针对事件的不同处理，插拔式组件；RadioWaveObject，事件载体，除了包含事件ID外还包括其他附加信息。

Antenna接收到事件后，会尝试发送到各个渠道，发送失败则保存到本地，待后续发送。

![](https://github.com/BrooksWon/AntennaSDK/blob/main/evcentRout.png)



## 写在最后:
目的: 为了是现有工程0改动接入组件, 防止了业务class侵入AntennaSDK.
采取了以下两种措施:

1. 新增`Antenna+POP.h`, 封装了对`Antenna` 的调用; 
2. 在 `POPAspect` hook `viewWillAppear` 方法, 为 `UIViewController`提前注册 pop_eventName.


## License

AntennaSDK is available under the MIT license. See the LICENSE file for more info.

