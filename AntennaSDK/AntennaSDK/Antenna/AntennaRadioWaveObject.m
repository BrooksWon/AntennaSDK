//
//  AntennaRadioWaveObject.m
//  AntennaSDKDemo
//
//  Created by Brooks on 2018/1/12.
//  Copyright © 2018年 Brooks. All rights reserved.
//

#import "AntennaRadioWaveObject.h"

@implementation EventPayload

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.event      = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(event))];
        self.content    = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(content))];
        self.ss         = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(ss))];
        self.loginToken = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(loginToken))];
        self.uuid       = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(uuid))];
        self.deviceId   = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(deviceId))];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.event forKey:NSStringFromSelector(@selector(event))];
    [aCoder encodeObject:self.content forKey:NSStringFromSelector(@selector(content))];
    [aCoder encodeObject:self.ss forKey:NSStringFromSelector(@selector(ss))];
    [aCoder encodeObject:self.loginToken forKey:NSStringFromSelector(@selector(loginToken))];
    [aCoder encodeObject:self.uuid forKey:NSStringFromSelector(@selector(uuid))];
    [aCoder encodeObject:self.deviceId forKey:NSStringFromSelector(@selector(deviceId))];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    if (self.event) dictionary[NSStringFromSelector(@selector(event))]           = self.event;
    if (self.content) dictionary[NSStringFromSelector(@selector(content))]       = self.content;
    if (self.ss) dictionary[NSStringFromSelector(@selector(ss))]                 = self.ss;
    if (self.loginToken) dictionary[NSStringFromSelector(@selector(loginToken))] = self.loginToken;
    if (self.uuid) dictionary[NSStringFromSelector(@selector(uuid))]             = self.uuid;
    if (self.deviceId) dictionary[NSStringFromSelector(@selector(deviceId))]     = self.deviceId;
    
    return [dictionary copy];
}

- (NSString *)description {
    NSDictionary *dictionary = [self toDictionary];
    
    NSData *jsonData   = nil;
    NSError *jsonError = nil;
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&jsonError];
    } @catch (NSException *exception) {
        // this should not happen in properly design
        // usually means there was no reverse transformer for a custom property
        NSLog(@"eventPayload JSON serialization exception: %@", exception.description);
        return @"{}";
    }
    
    if (!jsonData) {
        return @"{}";
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end


@implementation AntennaRadioWaveObject

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.v       = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(v))];
        self.hn      = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(hn))];
        self.u       = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(u))];
        self.dt      = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(dt))];
        self.refer   = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(refer))];
        self.ep      = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(ep))];
        self.ac      = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(ac))];
        self.ts      = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(ts))];
        self.sid     = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(sid))];
        self.source  = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(source))];
        self.uuid    = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(uuid))];
        self.userid  = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userid))];
        self.appv    = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(appv))];
        self.osv     = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(osv))];
        self.model   = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(model))];
        self.channel = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(channel))];
        self.rukou   = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(rukou))];
        self.imei    = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(imei))];
        self.city    = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(city))];
        self.crc     = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(crc))];
        self.pkgID   = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(pkgID))];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.v forKey:NSStringFromSelector(@selector(v))];
    [aCoder encodeObject:self.hn forKey:NSStringFromSelector(@selector(hn))];
    [aCoder encodeObject:self.u forKey:NSStringFromSelector(@selector(u))];
    [aCoder encodeObject:self.dt forKey:NSStringFromSelector(@selector(dt))];
    [aCoder encodeObject:self.refer forKey:NSStringFromSelector(@selector(refer))];
    [aCoder encodeObject:self.ep forKey:NSStringFromSelector(@selector(ep))];
    [aCoder encodeObject:self.ac forKey:NSStringFromSelector(@selector(ac))];
    [aCoder encodeObject:self.ts forKey:NSStringFromSelector(@selector(ts))];
    [aCoder encodeObject:self.sid forKey:NSStringFromSelector(@selector(sid))];
    [aCoder encodeObject:self.source forKey:NSStringFromSelector(@selector(source))];
    [aCoder encodeObject:self.uuid forKey:NSStringFromSelector(@selector(uuid))];
    [aCoder encodeObject:self.userid forKey:NSStringFromSelector(@selector(userid))];
    [aCoder encodeObject:self.appv forKey:NSStringFromSelector(@selector(appv))];
    [aCoder encodeObject:self.osv forKey:NSStringFromSelector(@selector(osv))];
    [aCoder encodeObject:self.model forKey:NSStringFromSelector(@selector(model))];
    [aCoder encodeObject:self.channel forKey:NSStringFromSelector(@selector(channel))];
    [aCoder encodeObject:self.rukou forKey:NSStringFromSelector(@selector(rukou))];
    [aCoder encodeObject:self.imei forKey:NSStringFromSelector(@selector(imei))];
    [aCoder encodeObject:self.city forKey:NSStringFromSelector(@selector(city))];
    [aCoder encodeObject:self.crc forKey:NSStringFromSelector(@selector(crc))];
    [aCoder encodeObject:self.pkgID forKey:NSStringFromSelector(@selector(pkgID))];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (self.v) dictionary[NSStringFromSelector(@selector(v))]             = self.v;
    if (self.hn) dictionary[NSStringFromSelector(@selector(hn))]           = self.hn;
    if (self.u) dictionary[NSStringFromSelector(@selector(u))]             = self.u;
    if (self.dt) dictionary[NSStringFromSelector(@selector(dt))]           = self.dt;
    if (self.refer) dictionary[NSStringFromSelector(@selector(refer))]     = self.refer;
    if (self.ep) dictionary[NSStringFromSelector(@selector(ep))]           = [self.ep description];
    if (self.ac) dictionary[NSStringFromSelector(@selector(ac))]           = self.ac;
    if (self.ts) dictionary[NSStringFromSelector(@selector(ts))]           = self.ts;
    if (self.sid) dictionary[NSStringFromSelector(@selector(sid))]         = self.sid;
    if (self.source) dictionary[NSStringFromSelector(@selector(source))]   = self.source;
    if (self.uuid) dictionary[NSStringFromSelector(@selector(uuid))]       = self.uuid;
    if (self.userid) dictionary[NSStringFromSelector(@selector(userid))]   = self.userid;
    if (self.appv) dictionary[NSStringFromSelector(@selector(appv))]       = self.appv;
    if (self.osv) dictionary[NSStringFromSelector(@selector(osv))]         = self.osv;
    if (self.model) dictionary[NSStringFromSelector(@selector(model))]     = self.model;
    if (self.channel) dictionary[NSStringFromSelector(@selector(channel))] = self.channel;
    if (self.rukou) dictionary[NSStringFromSelector(@selector(rukou))]     = self.rukou;
    if (self.imei) dictionary[NSStringFromSelector(@selector(imei))]       = self.imei;
    if (self.city) dictionary[NSStringFromSelector(@selector(city))]       = self.city;
    if (self.crc) dictionary[NSStringFromSelector(@selector(crc))]         = self.crc;
    if (self.pkgID) dictionary[NSStringFromSelector(@selector(pkgID))]     = self.pkgID;
    
    return [dictionary copy];
}

- (NSString *)description {
    NSDictionary *dictionary = [self toDictionary];
    
    NSData *jsonData = nil;
    NSError *jsonError = nil;
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&jsonError];
    } @catch (NSException *exception) {
        // this should not happen in properly design
        // usually means there was no reverse transformer for a custom property
        NSLog(@"radioWaveObject JSON serialization exception: %@", exception.description);
        return @"{}";
    }
    
    if (!jsonData) {
        return @"{}";
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[AntennaRadioWaveObject class]]) {
        return NO;
    }
    
    return [self isEqualToRadioWave:(AntennaRadioWaveObject *)object];
}

- (BOOL)isEqualToRadioWave:(AntennaRadioWaveObject *)radioWave {
    if (!radioWave) {
        return NO;
    }
    
    return [self.ts isEqualToString:radioWave.ts] && [self.crc isEqualToString:radioWave.crc];
}

@end

