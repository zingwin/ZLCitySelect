//
//  ViewController.m
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import "ViewController.h"
#import "ZLSelectCityViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *selectCityLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ZLSelectCityViewController *selectCityVC = [segue destinationViewController];
    selectCityVC.selectCityBlock = ^(NSDictionary* city){
        self.selectCityLabel.text = [NSString stringWithFormat:@"您选择的城市：%@",[city objectForKey:@"name"]];
    };
}
@end
