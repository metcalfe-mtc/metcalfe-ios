//
//  AddAssetsListCell.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/14.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AddAssetsListCell.h"

@implementation AddAssetsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if(self.trusted){
        self.trusted(!self.trustStatus, button.tag);
    }
}


@end
