//
//  FileTableViewCell.m
//  FileManagerUi
//
//  Created by mt010 on 2020/7/1.
//  Copyright © 2020 FileManager. All rights reserved.
//

#import "FileTableViewCell.h"
static NSString *fileCell = @"FileCellID";

@implementation FileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageHeaderView = [UIImageView new];
        _titleLabel = [UILabel new];
        _describeLabel = [UILabel new];
        _backImageView = [UIImageView new];
        [self.contentView addSubview:_imageHeaderView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_describeLabel];
        [self.contentView addSubview:_backImageView];
    }
    return self;
}
- (void)setCellUI{
    
}
- (void)config:(DZGCellModel *)model
{
    self.imageHeaderView.image = [UIImage imageNamed:model.imageHeaderView_image];
    self.titleLabel.text = model.titleLabel_text;
    self.describeLabel.text = model.describeLabel_text;
    self.backImageView.image = [UIImage imageNamed:model.backImageView_image];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
