//
//  DZGCellModel.m
//  FileManagerUi
//
//  Created by mt010 on 2020/7/22.
//  Copyright © 2020 FileManager. All rights reserved.
//

#import "DZGCellModel.h"

@implementation DZGCellModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 防止崩溃
#ifdef DEBUG
    NSLog(@"[YHPersonalDataModel] 相关 key 值：%@", key);
#else
#endif
}
@end
