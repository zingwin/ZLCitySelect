//
//  HotCityCityCell.h
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectHotCityBlock)(NSDictionary* city);

@interface ZLHotCityCityCell : UITableViewCell
@property(nonatomic,copy) SelectHotCityBlock selectHotCityBlock;
-(void)fillCellContent:(NSArray*)hotCitys;
+(CGFloat)heightForHotCell:(NSArray*)hotcitys;
@end
