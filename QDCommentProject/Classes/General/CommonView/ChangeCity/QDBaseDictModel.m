//
//  QDBaseDictModel.m
//  DigitalTalent
//
//  Created by qiaodaImac on 2018/1/19.
//  Copyright © 2018年 数字英才. All rights reserved.
//

#import "QDBaseDictModel.h"

@implementation QDBaseDictModel

MJCodingImplementation;

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"hot": @"QDAreaModel", @"area": @"QDAreaModel"};
}

@end

@implementation QDAreaModel

MJCodingImplementation;

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"children": @"QDAreaModel"};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.children = [[NSArray alloc]init];
    }
    return self;
}

- (NSString *)areaName {
    if (_areaName.length > 0) {
        
        if ([[_areaName substringFromIndex:_areaName.length - 1] isEqualToString:@"市"]) {
            _areaName = [_areaName substringToIndex:_areaName.length - 1];
        }
    }
    return _areaName;
}

- (NSMutableArray *)childrenModelArray {
    if (!_childrenModelArray) {
        _childrenModelArray = [[NSMutableArray alloc]init];
        if (self.children.count) {
            _childrenModelArray = [QDAreaModel mj_objectArrayWithKeyValuesArray:self.children];
        }
    }
    return _childrenModelArray;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"id - %@     name - %@\n", self.code, self.areaName];
}

@end

