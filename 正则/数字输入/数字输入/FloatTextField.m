//
//  FloatTextField.m
//  NongChuMall
//
//  Created by Chaosky on 5/20/15.
//  Copyright (c) 2015 HeHui. All rights reserved.
//

#import "FloatTextField.h"

@implementation FloatTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //限制只能输入数字和小数点
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    if(!basicTest) {
        return NO;
    }
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString * regex = @"^((^0\\.\\d{0,2}$)|(^[1-9]+\\d*\\.\\d{0,2}$)|(^[1-9]\\d*$)|(^0$))?$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [predicate evaluateWithObject:searchStr];
    
    if (isMatch)
        return YES;
    else
        return NO;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.floatDelegate textFieldDidEndEditing:textField];
}

-(BOOL) respondsToSelector:(SEL)aSelector {
    
    NSString * selectorName = NSStringFromSelector(aSelector);
    
    if ([selectorName isEqualToString:@"customOverlayContainer"]) {
        
        NSLog(@"preventing self.delegate == self crash");
        
        return NO;
    }
    
    return [super respondsToSelector:aSelector];
}

@end
