ZLCitySelect
==============
城市选择工具，包括定位城市，热门城市，所有城市按照拼音首字母聚合以及搜索城市。<br/>

> ![demo1](https://github.com/zingwin/ZLCitySelect/blob/master/Demo/1.png)
> ![demo2](https://github.com/zingwin/ZLCitySelect/blob/master/Demo/2.png)

兼容性
==============
该项目能很好的兼容 iPhone,兼容 iOS7 / 8 / 9

用法
==============
    <code>
    ZLSelectCityViewController *selectCityVC = [[ZLSelectCityViewController alloc] init];
    selectCityVC.selectCityBlock = ^(NSDictionary* city){
        self.selectCityLabel.text = [NSString stringWithFormat:@"您选择的城市：%@",[city objectForKey:@"name"]];
    };
    [self.navigationController pushViewController:selectCityVC animated:YES];
    </code>
    
安装
==============

### 手动安装

1. 下载 ZLCitySelect 文件夹内的所有内容。
2. 将 ZLCitySelect 内的源文件添加(拖放)到你的工程。
3. 导入 `ZLCitySelect.h`。


许可证
==============
ZLCitySelect 使用 MIT 许可证，详情见 LICENSE 文件。
