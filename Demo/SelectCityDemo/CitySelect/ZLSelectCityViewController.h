//
//  SelectCityViewController.h
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectCityBlock)(NSDictionary* city);

@interface ZLSelectCityViewController : UIViewController
@property(nonatomic,copy) SelectCityBlock selectCityBlock;
@end
