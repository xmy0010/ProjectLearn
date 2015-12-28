//
//  CollectionViewCell.h
//  LimitFree_project
//
//  Created by 千锋 on 15/12/21.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteButtonClicked:(UIButton *)sender;



@end
