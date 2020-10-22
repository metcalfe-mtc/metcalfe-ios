//
//  WalletDetailCell.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/13.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "WalletDetailCell.h"
#import "Masonry.h"

@implementation WalletDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(15);
        make.centerY.equalTo(self.title.mas_centerY);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(11);
    }];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
