ZLCitySelect
==============
城市选择工具，包括定位城市，热门城市，所有城市按照拼音首字母聚合以及搜索城市。<br/>

> ![demo](https://github.com/zingwin/ZLCitySelect/new/master/Demo/1.png)
> ![demo](https://github.com/zingwin/ZLCitySelect/new/master/Demo/2.png)

兼容性
==============
该项目能很好的兼容 iPhone,兼容 iOS7 / 8 / 9

用法
==============
	// 获取键盘管理器
	YYKeyboardManager *manager = [YYKeyboardManager defaultManager];
	
	// 获取键盘的 view 和 window
	UIView *view = manager.keyboardView;
	UIWindow *window = manager.keyboardWindow;
	
	// 获取键盘当前状态
	BOOL visible = manager.keyboardVisible;
	CGRect frame = manager.keyboardFrame;
	frame = [manager convertRect:frame toView:self.view];
	
	// 监听键盘动画
	[manager addObserver:self];
	- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition {
	    CGRect fromFrame = [manager convertRect:transition.fromFrame toView:self.view];
	    CGRect toFrame =  [manager convertRect:transition.toFrame toView:self.view];
	    BOOL fromVisible = transition.fromVisible;
	    BOOL toVisible = transition.toVisible;
	    NSTimeInterval animationDuration = transition.animationDuration;
	    UIViewAnimationCurve curve = transition.animationCurve;
	}


安装
==============

### 手动安装

1. 下载 ZLCitySelect 文件夹内的所有内容。
2. 将 ZLCitySelect 内的源文件添加(拖放)到你的工程。
3. 导入 `ZLCitySelect.h`。


许可证
==============
ZLCitySelect 使用 MIT 许可证，详情见 LICENSE 文件。
