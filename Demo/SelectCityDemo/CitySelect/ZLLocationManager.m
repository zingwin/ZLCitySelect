//
//  GLLocationManager.m
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import "ZLLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface ZLLocationManager()<CLLocationManagerDelegate>
{
    BOOL isUpdatingUserLocation;
    BOOL isOnlyOneRefresh;
    
    CLLocationManager *userLocationManager;
    NSTimeInterval locatedate;
}
@end
@implementation ZLLocationManager
+ (ZLLocationManager *)sharedManager{
    static ZLLocationManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ZLLocationManager alloc] init];
    });
    
    return _sharedClient;
}
- (id)init
{
    NSLog(@"[%@] init:", NSStringFromClass([self class]));
    if (self = [super init]) {
        isUpdatingUserLocation = NO;
        isOnlyOneRefresh = NO;
        
        userLocationManager = [[CLLocationManager alloc] init];
        userLocationManager.distanceFilter  = 100;
        userLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        userLocationManager.headingFilter   = kCLLocationAccuracyBestForNavigation;
        userLocationManager.delegate = self;
        if ([userLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [userLocationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

-(BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

-(void)StartLocation
{
    if ([CLLocationManager respondsToSelector:@selector(authorizationStatus)]) {
        CLAuthorizationStatus b=[CLLocationManager authorizationStatus];
        if (b == kCLAuthorizationStatusDenied || b == kCLAuthorizationStatusNotDetermined){
            //NSString *message = @"请打开系统设置“隐私→定位服务”，允许“微字”使用您的位置。";
//            return;
        }
    }
    
    [userLocationManager startUpdatingLocation];
}

-(void)ReobtainLocation
{
    [userLocationManager stopUpdatingLocation];
    [userLocationManager startUpdatingLocation];
}

#pragma mark locationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
//    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //earth2mars(&(newCoordinate.latitude),&(newCoordinate.longitude));
//    double lon = newCoordinate.longitude;
//    double lat = newCoordinate.latitude;

    if ([[NSDate date] timeIntervalSince1970] - locatedate > 3 ) {
        //两次定位时间间隔超过3秒才通知
        locatedate = [[NSDate date] timeIntervalSince1970];
        //反地理编码
        [self geocoderWithNewLocation:newLocation andOldLocation:oldLocation];
    }
}

- (void)geocoderWithNewLocation:(CLLocation *)newLocation andOldLocation:(CLLocation *)oldLocation {
    CLGeocoder *geocode = [[CLGeocoder alloc] init];
    [geocode reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            //失败
            [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserLocationDidChangeOrFailNotification
                                                                object:self
                                                              userInfo:@{GLLocationManagerNotificationErrorInfoKey:error}];
            //[self geocoderWithNewLocation:newLocation andOldLocation:oldLocation];//再次请求
        } else { // 编码成功（找到了具体的位置信息）
            // 输出查询到的所有地标信息
            NSString *city = nil;
            for (CLPlacemark *placemark in placemarks) {
                NSDictionary *addressDictionary = placemark.addressDictionary;
                city = addressDictionary[@"State"];
                city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            }
            
            NSMutableDictionary *inforDict = [NSMutableDictionary dictionary];
            if (newLocation) {
                [inforDict setObject:newLocation forKey:@"kNewLocationKey"];
            }
            if (oldLocation) {
                [inforDict setObject:oldLocation forKey:@"kOldLocationKey"];
            }
            if (city) {
                [inforDict setObject:city forKey:@"kCityKey"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserLocationDidChangeOrFailNotification
                                                                    object:self
                                                                  userInfo:inforDict];
            });
            //userInfo != nil: newLocation and oldLocation is returned in userInfo
            //attention: oldLocation may be nil, so I use dictionaryWithObjectsAndKeys instead of @{}.
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserLocationDidChangeOrFailNotification
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error, GLLocationManagerNotificationErrorInfoKey, nil]];
    //[self AutoDisplayAlertView:@"提示" :@"定位失败~"];
}

@end
