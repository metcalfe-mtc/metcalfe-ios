//
//  AssetWalletListCell.m
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/15.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "AssetWalletListCell.h"
#import "Masonry.h"
@interface AssetWalletListCell ()
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;

@end
@implementation AssetWalletListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kWidth(10));
    }];
    
    [self.activeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.contentView.mas_right).offset(-14);
        make.centerY.equalTo(self.contentView.mas_top).offset(14);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    
    self.activeLabel.transform = CGAffineTransformMakeRotation(M_PI/4);
    self.contentView.backgroundColor = RGB(246, 246, 246);
}

-(void)setupCellWithModel:(LocalWallet *)model{
    if([model.isdefault isEqualToString:@"1"]){
        self.iconViewWidth.constant = 30;
        self.defaultImage.backgroundColor = RGB(230, 230, 230);
        
    }else{
        self.iconViewWidth.constant = 0;
        self.defaultImage.backgroundColor = [UIColor whiteColor];
        
    }
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.account;
    self.activeLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
