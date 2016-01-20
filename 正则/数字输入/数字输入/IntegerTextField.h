//
//  IntegerTextField.h
//  NongChuMall
//
//  Created by Chaosky on 5/20/15.
//  Copyright (c) 2015 HeHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntegerTextFieldDelegate;

@interface IntegerTextField : UITextField<UITextFieldDelegate>
@property(nonatomic,assign) id<IntegerTextFieldDelegate> integerDelegate;
@end

@protocol IntegerTextFieldDelegate <UITextFieldDelegate>


@end
