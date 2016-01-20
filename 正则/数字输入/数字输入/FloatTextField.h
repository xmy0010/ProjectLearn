//
//  FloatTextField.h
//  NongChuMall
//
//  Created by Chaosky on 5/20/15.
//  Copyright (c) 2015 HeHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FloatTextFieldDelegate;

@interface FloatTextField : UITextField<UITextFieldDelegate>
@property(nonatomic,assign) id<FloatTextFieldDelegate> floatDelegate;
@end

@protocol FloatTextFieldDelegate <UITextFieldDelegate>


@end