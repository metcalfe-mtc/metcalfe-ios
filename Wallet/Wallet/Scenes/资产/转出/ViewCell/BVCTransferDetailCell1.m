//
//  BVCTransferDetailCell1.m
//  BVCPay
//
//  Created by 钱伟成 on 2019/1/18.
//  Copyright © 2019年 智能流量链联盟. All rights reserved.
//

#import "BVCTransferDetailCell1.h"
#import "YYText.h"

@implementation BVCTransferDetailCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cpButtonAction:(id)sender {
    UIButton *buton = (UIButton *)sender;
    if(self.cpBlock){
        self.cpBlock(buton.tag);
    }
}
@end
