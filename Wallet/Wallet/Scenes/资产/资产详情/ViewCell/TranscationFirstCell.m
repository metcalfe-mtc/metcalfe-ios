//
//  TranscationFirstCell.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/22.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "TranscationFirstCell.h"

@implementation TranscationFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.text = GetStringWithKeyFromTable(@"交易记录_title", LOCALIZABE, nil);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
