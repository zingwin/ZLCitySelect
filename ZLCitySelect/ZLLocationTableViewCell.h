//
//  LocationTableViewCell.h
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LOCATIONSTATUS) {
    //以下是枚举成员
    LOCATIONSTATUSFail = 0,
    LOCATIONSTATUSING = 1,
    LOCATIONSTATUSSUCCESS = 2,
};

@interface ZLLocationTableViewCell : UITableViewCell
-(void)fillViewContent:(NSDictionary*)dic;
@end
