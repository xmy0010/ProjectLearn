//
//  ParallaxCell.m
//  ParallaxDemo
//
//  Created by 千锋 on 15/12/28.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "ParallaxCell.h"

@interface ParallaxCell ()

@property (weak, nonatomic) IBOutlet UIImageView *parallaxImageView;

@end


@implementation ParallaxCell

- (void)setImageName:(NSString *)imageName {

    //调用setter方法的时候
    self.parallaxImageView.image = [UIImage imageNamed:imageName];
}


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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
