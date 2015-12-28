//
//  ViewController.m
//  ParallaxDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "ViewController.h"
#import "ParallaxCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *imgNames;  //数据源

@end

@implementation ViewController

//惰性加载
- (NSMutableArray *)imgNames {

    if (_imgNames == nil) {
        _imgNames = @[].mutableCopy;
        
        for (int index = 0; index < 14; index++) {
            NSString *imgName = [NSString stringWithFormat:@"image%03d.jpg", index];
            [_imgNames addObject:imgName];
        }
    }
    return _imgNames;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
}


#pragma mark - <UITableViewDataSource, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.imgNames.count;
    //不能用_imgNames
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParallaxCellID"];
    cell.imageName = self.imgNames[indexPath.row];
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 160.;
}
//只要tableView滑动 cell就跟着滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //获取tableView里面 所有显示的cell
    NSArray *cells = [self.tableView visibleCells];
    //循环所有的可视cell 让cell的parallaxImageView的位置改变
    for (ParallaxCell *cell in cells) {
        [cell scrollImageInTableView:self.tableView inView:self.view];
    }
}

@end
