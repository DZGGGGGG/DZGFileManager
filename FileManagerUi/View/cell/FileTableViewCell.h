//
//  FileTableViewCell.h
//  FileManagerUi
//
//  Created by mt010 on 2020/7/1.
//  Copyright © 2020 FileManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileTableViewCell : UITableViewCell


// 左边的图片, 需要注意: 不要和父类的imageView属性冲突
@property (nonatomic, strong) UIImageView *imageHeaderView;
// 文件的名称
@property (nonatomic, strong) UILabel *titleLabel;
// 文件的描述
@property (nonatomic, strong) UILabel *describeLabel;
// 返回按钮
@property (nonatomic, strong) UIImageView *backImageView;

// 用于传输model显示数据
- (void)config:(DZGCellModel *)model;
@end

NS_ASSUME_NONNULL_END
