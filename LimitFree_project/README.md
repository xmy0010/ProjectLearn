#LimiteFree 项目

##语法技巧
###1.*枚举值与数组下标联系* 枚举值的运用即由枚举本身表示的状态用法，又有其类型数值用法 特别的单纯0，1，2，3...类型的枚举值可以作为数组的下标。通过下列列子和对不同状态的枚举值取得不同数组中的value而不用取遍历数组，次用法需注意枚举值中最大值要小于数组元素的个数

	typedef NS_ENUM(NSUInteger, RefreshStatus) {
    RefreshStatusNotVisiable = 0, //不可见隐藏
    RefreshStatusLoading,         //加载中...
    RefreshStatusFailure,         //加载失败
    RefreshStatusMore,            //加载更多
    RefreshStatusNotMore         //没有更多数据了
 	};
 	
 	RefreshStatus statu;
 	NSArray *array = @[@"xxx", @"xxx", @"xxx", @"xxx", @"xxx", @"xxx"];
 	NSString *string = array[statu];
 	
--
###2.*重写属性的setter和getter方法*	声明为property的变量系统会自动生成简单的setter和getter方法，但是经常需要重写这俩个方法。 另外需注意若同时重写了setter和getter方法，要在类的实现加上语句`@synthesize manager = _manager;`或者声明一个`SomeClass *_mananer;`

####+*重写getter方法* getter方法在`self.manager`作为右值时调用.例如*例1*惰性初始化时候可以重写getter方法。需注意惰性初始化的好处是在用`self.manager`语句作为右值调用时才会生成mannager实例对象。且重写时候再用`_manager`直接访问实例对象的话需要自己**手动生成相应的对象**. 或者*例2*中对属性保护隐藏属性不允许外界修改可以这样重写
 	```例1
	- (LimitFressNetworkingManager *)manager {

    	if (_manager == nil) {
       	 _manager = [LimitFressNetworkingManager 	manager];
    	}//此处调用了该类的工厂方法
    	return _manager;
	}	
---	
例2.在.h文件中`@property(nonatomic, strong) NSArray *array1;`在.m文件匿名类中声明`NSArray *array2;`然后下面重写array1的getter来返回array2。当然也可以不要array1直接`@property(noatomic, strong, readonly) NSArray *array2`这样的语句来readonly修饰的属性**只有在初始化函数中才能设置**
		
	- (NSArray*)array1 {
		return array2;
	}
	

	

####+*重写setter方法*	 setter方法在`self.status`作为左值时候调用。一种情况是下列在为属性设置值时同时会产生其他的一些变化，这样写之后可以每次左值调用可以动态的绑定该属性与对应的变化。	
 	``` 例1
 	 -(void)setStatus:(RefreshStatus)status {
   		 _status = status;
   		 NSArray *textArray = @[@"", @"", @"failed",  @"more", @"nomore"];
    	*_textLable.text = textArray[_status]; *
    	if (status == RefreshStatusLoading) {
        	_indicatorView.hidden = NO;
        	[_indicatorView startAnimating];
   	    } else {
        	_indicatorView.hidden = YES;
        	[_indicatorView stopAnimating];
   		 }
	}
--- ```
 	


##问题记录
####1.-button的frame超过或者等于父视图会造成无法响应点击。
####2.-attributedString中设置的attributes字典里面经常value值为NSInter需要转为NSNumber
####3.-将ViewController放上NavigationController之后 设置`self.navigationController.navigationBar.translucent = YES`可以让添加到`self.view`中的子视图的frame的高度从64开始计算 不然默认NO是从0开始计算。
####4.-关于tableView自定cell的时候`UITableViewCell`类创建的对象会自带一个imageView属性 自定的cell里面有也有相同命名的imageView有时会造成错误。
####5.关于自定义cell的时候Cell的高度不确定问题。 但是内部控件排版几乎一样需要复用 如新闻内cell 每篇详情只有新闻内容的长度不同