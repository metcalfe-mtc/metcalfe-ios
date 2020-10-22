//
//  MineCell.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/4.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.upDateButton setTitle:GetStringWithKeyFromTable(@"更新_massage", LOCALIZABE, nil) forState:UIControlStateNormal];
    self.versionLabel.text = GetStringWithKeyFromTable(@"已经是最新版本了_massage", LOCALIZABE, nil);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
