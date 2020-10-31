//
//  AssetsFirstCell.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/3.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AssetsFirstCell.h"

@interface AssetsFirstCell()
@property (weak, nonatomic) IBOutlet UILabel *assets;
@property (weak, nonatomic) IBOutlet UIButton *creditButton;

@end

@implementation AssetsFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.assets.text = GetStringWithKeyFromTable(@"资产_text", LOCALIZABE, nil);

}
- (IBAction)creditAction:(id)sender {
    if(self.creditBlock){
        self.creditBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
