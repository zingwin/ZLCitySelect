//
//  LocationTableViewCell.m
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import "ZLLocationTableViewCell.h"
@interface ZLLocationTableViewCell()
{
    UILabel *cityNameLabel;
    UIActivityIndicatorView *juhua;
}
@end

@implementation ZLLocationTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 44)];
        cityNameLabel.textColor = [UIColor blackColor];
        cityNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:cityNameLabel];
        
        juhua = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        juhua.center = CGPointMake(self.frame.size.width-30, 22);
        juhua.color = [UIColor blackColor];
        [juhua setHidesWhenStopped:YES];
        [self addSubview:juhua];
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
    id cityStatus = [dic objectForKey:@"cityStatus"];
    if (cityStatus) {
        //定位中  定位失败
        if([cityStatus integerValue] == LOCATIONSTATUSING){
            [juhua startAnimating];
            cityNameLabel.text = @"定位中";
        }else if ([cityStatus integerValue] == LOCATIONSTATUSFail){
            cityNameLabel.text = @"定位失败";
            [juhua stopAnimating];
        }
    }else{
        //定位成功
        cityNameLabel.text = [dic objectForKey:@"name"];
        [juhua stopAnimating];
    }
}
@end
