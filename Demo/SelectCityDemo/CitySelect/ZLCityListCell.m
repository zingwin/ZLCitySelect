//
//  CityListCell.m
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import "ZLCityListCell.h"
@interface ZLCityListCell()
{
    UILabel *cityNameLabel;
}
@end

@implementation ZLCityListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 44)];
        cityNameLabel.textColor = [UIColor blackColor];
        cityNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:cityNameLabel];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillViewContent:(NSDictionary*)dic{
    cityNameLabel.text = [dic objectForKey:@"name"];;
}
@end
