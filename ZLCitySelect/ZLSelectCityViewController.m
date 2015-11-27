//
//  SelectCityViewController.m
//  SelectCityDemo
//
//  Created by zingwin on 15/11/16.
//  Copyright © 2015年 zwin. All rights reserved.
//

#import "ZLSelectCityViewController.h"
#import "ZLHotCityCityCell.h"
#import "ZLCityListCell.h"
#import "ZLLocationTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "ZLLocationManager.h"

@interface ZLSelectCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
{
    
}
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UISearchBar *citySearchBar;
@property(nonatomic,strong) UISearchDisplayController *citySearchDisplayController;

@property(nonatomic,strong) NSMutableArray*  hotCityDataArray;   //热门城市
@property(nonatomic,strong) NSMutableArray*  allCityDataArray;   //所有城市
@property(nonatomic,strong) NSMutableArray*  searchResultArray;  //查找结果
@property(nonatomic,strong) NSMutableArray*  firstLetterKeysArray;//首字母
@property(nonatomic,strong) NSMutableDictionary* citiesDictionary; //tableview 非查询态数据源
@end

@implementation ZLSelectCityViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize  screenSize = [UIScreen mainScreen].bounds.size;
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:mainTableView];
    
    _citySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width,44)];
    _citySearchBar.barStyle = UIBarStyleDefault;
    _citySearchBar.tintColor = [UIColor blackColor];
    
    _citySearchBar.delegate = self;
    _citySearchBar.placeholder = @"请输入要查找的城市...";
    _citySearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    mainTableView.tableHeaderView = _citySearchBar;
    
    _citySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_citySearchBar contentsController:self];
    _citySearchDisplayController.searchResultsDelegate = self;
    _citySearchDisplayController.searchResultsDataSource = self;
    _citySearchDisplayController.delegate = self;
    self.searchResultArray = [NSMutableArray array];
    
    //城市数据源
    [self requestCityList];
    
    //开始定位
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationChanged:)
                                                 name:GLLocationManagerUserLocationDidChangeOrFailNotification
                                               object:nil];
    [[ZLLocationManager sharedManager]  StartLocation];
}

- (void)locationChanged:(NSNotification *)note
{
    NSDictionary* userInfo = note.userInfo;
    NSError* error = [userInfo objectForKey:GLLocationManagerNotificationErrorInfoKey];
    if(error){
        [_citiesDictionary setObject:@[@{@"name":@"定位失败",@"cityStatus":@(LOCATIONSTATUSFail)}] forKey:@"#"];
        [self.mainTableView reloadData];
        return;
    }
    
    //定位成功，获取到newLocation和oldLocation
    NSString *locationCityName = [userInfo objectForKey:@"kCityKey"];
    NSDictionary* locationCity = nil;
    for (id city in _allCityDataArray) {
        NSString *cityName = [city valueForKeyPath:@"name"];
        if ([locationCityName isEqualToString:cityName]) {
            locationCity = city;
        }
    }
    [_citiesDictionary setObject:@[locationCity] forKey:@"#"];
    [self.mainTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userSelectCity:(NSDictionary*)city
{
    if (self.selectCityBlock) {
        self.selectCityBlock(city);
    }
    NSLog(@"用户选择的城市 %@",city);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestCityList
{
    //load from plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSDictionary *city = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *hotCity = city[@"hotcity"];
    NSArray *allCity = city[@"allcity"];
    
    _allCityDataArray = [NSMutableArray array];
    _hotCityDataArray  = [NSMutableArray array];
    _citiesDictionary = [[NSMutableDictionary alloc]  init];
    _firstLetterKeysArray = [[NSMutableArray alloc] init];

    //热门城市数据
    for (int i = 0; i < hotCity.count; i ++) {
        [_hotCityDataArray addObject:hotCity[i]];
    }
    
    //所有城市数据
    for (int i = 0; i < allCity.count; i ++) {
        [_allCityDataArray addObject: allCity[i]];
    }
    
    //定位城市
    if (![[ZLLocationManager sharedManager] locationServicesEnabled]) {
        [_citiesDictionary setObject:@[@{@"name":@"定位失败",@"cityStatus":@(LOCATIONSTATUSFail)}] forKey:@"#"];
    }else{
        [_citiesDictionary setObject:@[@{@"name":@"定位中",@"cityStatus":@(LOCATIONSTATUSING)}] forKey:@"#"];
    }
    [_firstLetterKeysArray addObject:@"#"];
    
    //热门城市
    [_citiesDictionary setObject:@[_hotCityDataArray] forKey:@"*"];
    [_firstLetterKeysArray addObject:@"*"];
    
    //所有城市A-Z
    for (int i = 0; i< [_allCityDataArray count]; i++) {
        NSDictionary *city = _allCityDataArray[i];
        NSString *firstLetter = [[city objectForKey:@"pinyin"] substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];
        if ([_citiesDictionary objectForKey:firstLetter]) {
            [[_citiesDictionary objectForKey:firstLetter] addObject:city];
        }else{
            NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:city, nil];
            [_citiesDictionary setObject:arr forKey:firstLetter];
        }
    }
    
    [_firstLetterKeysArray setArray:[[_citiesDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    [mainTableView reloadData];
}

#pragma mark - uitableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == mainTableView) {
        return 25;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    NSArray *titleArray = @[@"定位城市",@"热门城市",@"所以城市"];
    if (tableView == mainTableView) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
        v.backgroundColor = [UIColor lightGrayColor];
        
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, v.frame.size.width, v.frame.size.height)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [v addSubview:titleLabel];
        if (section==0) {
            titleLabel.text = @"定位城市";
        }else if(section==1){
            titleLabel.text = @"热门城市";
        }else{
            titleLabel.text = _firstLetterKeysArray[section];
        }
        return v;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==mainTableView) {
        if (indexPath.section==0) {
            //定位城市
            return 44;
        }else if(indexPath.section==1){
            //热门城市
            NSString *key = [_firstLetterKeysArray objectAtIndex:indexPath.section];
            NSArray *arr =  [[_citiesDictionary objectForKey:key] objectAtIndex:indexPath.row];
            return [ZLHotCityCityCell heightForHotCell:arr];
        }else {
            //所有城市
            return 44;
        }
    }
        return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *selectedCity;
    if (tableView == mainTableView)
    {
        NSString* letter = [_firstLetterKeysArray objectAtIndex:indexPath.section];
        if([letter isEqualToString:@"#"]){
            NSString *key = [_firstLetterKeysArray objectAtIndex:indexPath.section];
            NSDictionary *city =  [[_citiesDictionary objectForKey:key] objectAtIndex:indexPath.row];
            id cityStatus = [city objectForKey:@"cityStatus"];
            if (cityStatus) {
                //定位失败
                //定位服务不可用
                if([CLLocationManager locationServicesEnabled] &&
                   [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
                {
                    NSLog(@"定位服务未开启");
                }else{
                    [_citiesDictionary setObject:@[@{@"name":@"定位中",@"cityStatus":@(LOCATIONSTATUSING)}] forKey:@"#"];
                    [self.mainTableView reloadData];
                    [[ZLLocationManager sharedManager] ReobtainLocation];
                }
                //重新定位
            }else{
                [self userSelectCity:city];
            }
        }
        if (![letter isEqualToString:@"#"] && ![letter isEqualToString:@"*"]) {
            //直接选择城市
            NSString *key = [_firstLetterKeysArray objectAtIndex:indexPath.section];
            NSDictionary *city =  [[_citiesDictionary objectForKey:key] objectAtIndex:indexPath.row];
            [self userSelectCity:city];
        }
    }else{
        if (_searchResultArray && [_searchResultArray count] > 0)
        {
            selectedCity = [_searchResultArray objectAtIndex:indexPath.row];
            [self userSelectCity:selectedCity];
        }
    }
}

#pragma mark - UITableViewDatasource
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (tableView == mainTableView)
//    {
//        return _firstLetterKeysArray;
//    }
//    return nil;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == mainTableView)
    {
        return [_firstLetterKeysArray count];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == mainTableView){
        NSString *key = [_firstLetterKeysArray objectAtIndex:section];
        return [[_citiesDictionary objectForKey:key] count];
    }else if (_searchResultArray && [_searchResultArray count] > 0)
    {
        return [_searchResultArray count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==mainTableView){
        if (indexPath.section==0){
            ZLLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationcellid"];
            if (!cell) {
                cell = [[ZLLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationcellid"];
            }
            NSString *key = [_firstLetterKeysArray objectAtIndex:indexPath.section];
            NSDictionary *city =  [[_citiesDictionary objectForKey:key] objectAtIndex:indexPath.row];
            [cell fillViewContent:city];
            return cell;
        }else if (indexPath.section==1) {
            ZLHotCityCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotcitycellid"];
            if (!cell) {
                cell = [[ZLHotCityCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotcitycellid"];
            }
            NSString *key = [_firstLetterKeysArray objectAtIndex:indexPath.section];
            NSArray *arr =  [[_citiesDictionary objectForKey:key] objectAtIndex:indexPath.row];
            cell.selectHotCityBlock = ^(NSDictionary *city){
                [self userSelectCity:city];
            };
            [cell fillCellContent:arr];
            return cell;
        }else{
            ZLCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citylistcellid"];
            if (!cell) {
                cell = [[ZLCityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"citylistcellid"];
            }
            NSString *key = [_firstLetterKeysArray objectAtIndex:indexPath.section];
            NSDictionary *city =  [[_citiesDictionary objectForKey:key] objectAtIndex:indexPath.row];
            [cell fillViewContent:city];
            return cell;
        }
    }else{
        static NSString* identify = @"SearchResultIdentify";
        ZLCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[ZLCityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        NSDictionary* city = _searchResultArray[indexPath.row];
        [cell fillViewContent:city];
        return cell;
    }
    return nil;
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_citySearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self doSearch:searchBar.text];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText==nil || [searchText isEqualToString:@""]) {
        [_searchResultArray removeAllObjects];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    }
    [self doSearch:searchText];
}

- (void)doSearch:(NSString *)searchText {
    if (!_searchResultArray) {
        _searchResultArray = [[NSMutableArray alloc] init];
    }
    NSMutableArray* resultArray = [NSMutableArray array];
    if(searchText && [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        if(_allCityDataArray && [_allCityDataArray count] > 0) {
            for (int i = 0; i < [_allCityDataArray count]; i++) {
                NSDictionary *city = _allCityDataArray[i];
                NSString *cityName = [city objectForKey:@"name"];
                NSString *pinyin = [city objectForKey:@"pinyin"];
                if ([cityName containsString:searchText] ||
                    [pinyin hasPrefix:[searchText lowercaseString]]) {
                    [resultArray addObject:city];
                }
            }
        }
    }
    if (resultArray.count>0) {
        [_searchResultArray removeAllObjects];
        [_searchResultArray addObjectsFromArray:resultArray];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}
@end