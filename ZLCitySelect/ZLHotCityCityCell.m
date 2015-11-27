//
//  HotCityCityCell.m
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import "ZLHotCityCityCell.h"

#define BASE_TAG 9090

#define kColumnCount 3
#define kButtonWidth 90
#define kButtonHeight 30
#define kMarginLeft 15
#define kMarginRight 15
#define kMarginTop  10
#define kYGap   5

@interface ZLHotCityCityCell(){
}
@property (nonatomic, strong)NSArray* hotCityArray;
@end
@implementation ZLHotCityCityCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)fillCellContent:(NSArray*)hotCitys{
    self.hotCityArray = hotCitys;
    
    for (int i=0;i< hotCitys.count;i++) {

        NSString *name = nil;
        NSDictionary *city = hotCitys[i];
        
        UIButton* cityBtn = [self createBtnWithTag:i andCity:name];
        [self.contentView addSubview:cityBtn];
        
        [cityBtn setTitle:[city objectForKey:@"name"] forState:UIControlStateNormal];
        [self.contentView bringSubviewToFront:cityBtn];
    }
}

-(UIButton*)createBtnWithTag:(int)index andCity:(NSString *)cityName
{
    CGFloat xgap = ([UIScreen mainScreen].bounds.size.width-kColumnCount*kButtonWidth-kMarginLeft - kMarginRight)*1.0f / (kColumnCount-1);
    CGFloat offx = kMarginLeft + (index % kColumnCount)*kButtonWidth + (index%kColumnCount)*xgap;
    CGFloat offy = kMarginTop + (index / kColumnCount)*kButtonHeight + (index / kColumnCount)*kYGap;
    
    UIButton* cityBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cityBtn.frame = CGRectMake(offx, offy, kButtonWidth, kButtonHeight);
    [cityBtn setTitle:cityName forState:UIControlStateNormal];
    cityBtn.tag = index + BASE_TAG;
    cityBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cityBtn.layer.borderWidth = 1.0f;
    cityBtn.layer.cornerRadius = 5.0f;
    cityBtn.backgroundColor = [UIColor lightTextColor];
    cityBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [cityBtn addTarget:self action:@selector(cityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    return cityBtn;
}
- (void)awakeFromNib {
    // Initialization code
}

+(CGFloat)heightForHotCell:(NSArray*)hotcitys{
    NSInteger count = [hotcitys count];
    CGFloat height = ((count -1) / kColumnCount + 1)*(kButtonHeight+kYGap);
    height += kMarginTop;
    return height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cityBtnClicked:(UIButton*)sender{
    NSInteger index = sender.tag - BASE_TAG;
    NSDictionary *city = self.hotCityArray[index];
    if (self.selectHotCityBlock) {
        self.selectHotCityBlock(city);
    }
}
@end
