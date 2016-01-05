# ProjectLearnFromQianfeng
this project I learn in class of qianfeng, And I will update what I Iearn every day.

link my mini with github.

##Demo1是一个tableview的视差效果，具体实现根据tableview滑动时 里面的cell也有相应的互动

#### 核心功能为cell里面放一张大的图片，图片的size超过cell 通过拉动tableview来变化图片的center.y;其核心代码是在函数`scrollViewDidScroll:`里面，通过遍历所有可视cell,方法`[self.tableView visibleCells]`返回可视cells的数组；然后cell类里面写一个函数计算frame.
```Objective-C
- (void)scrollImageInTableView:(UITableView *)tableView inView:(UIView *)view {

    //1.获取当前cell在VC.view 中的相对frame
    CGRect inSuperViewRect = [tableView convertRect:self.frame toView:view];
    
    //2.获取当前cell的起始 y 离VC.view的中线的距离
    CGFloat disFromCenterY = CGRectGetMidY(view.frame) - CGRectGetMinY(inSuperViewRect);
    
    //3.获取parallaxImageView的高度和 cell高度的差值。
    CGFloat diff = CGRectGetHeight(self.parallaxImageView.frame) - CGRectGetHeight(self.frame);
    
    //4.获取移动多少像素  用Cell离中线Y距离和整个VC.view的高度之比 乘以图片和cell的高度差
    CGFloat moveDistance = disFromCenterY / CGRectGetHeight(view.frame) * diff;
    
    //5.让图片的frame移动距离 --movedis
    CGRect scrollRect = self.parallaxImageView.frame;
    scrollRect.origin.y = - (diff / 2.) + moveDistance;
    self.parallaxImageView.frame = scrollRect;
}


```

##Demo2通过第三方库RESideMenu实现一个侧滑效果
####关于分类里面添加属性property