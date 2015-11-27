//
//  GLLocationManager.h
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define GLLocationManagerUserLocationDidChangeOrFailNotification @"GLLocationManagerUserLocationDidChangeNotification"

//error Info
#define  GLLocationManagerNotificationErrorInfoKey  @"kErrorKey"

@interface ZLLocationManager : NSObject
+ (ZLLocationManager *)sharedManager;
- (BOOL)locationServicesEnabled;
-(void)StartLocation;
-(void)ReobtainLocation;
@end
