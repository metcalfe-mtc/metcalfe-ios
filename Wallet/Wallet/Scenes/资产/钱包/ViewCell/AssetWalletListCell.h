//
//  AssetWalletListCell.h
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/15.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetWalletListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconViewWidth;
-(void)setupCellWithModel:(LocalWallet *)model;

@end

NS_ASSUME_NONNULL_END
