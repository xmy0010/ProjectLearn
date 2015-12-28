//
//  AppdetailModel.m
//  LimitFree_project
//
//  Created by 千锋 on 15/12/17.
//  Copyright (c) 2015年 千锋. All rights reserved.
//

#import "AppdetailModel.h"

@implementation AppdetailModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    } 
}

- (void)setPhotos:(NSArray *)photos {

    NSMutableArray *photosModels = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in photos) {
        Photos *photo = [[Photos alloc] init];
        [photo setValuesForKeysWithDictionary:dict];
        [photosModels addObject:photo];
    }
    _photos = [photosModels copy];
    
}

+ (NSDictionary *)objectClassInArray{
    return @{@"photos" : [Photos class]};
}
@end
@implementation Photos




@end


