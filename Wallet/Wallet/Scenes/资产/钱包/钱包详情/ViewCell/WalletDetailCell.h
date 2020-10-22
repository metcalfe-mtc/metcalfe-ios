//
//  WalletDetailCell.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/13.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const WalletDetailCellIdentifier = @"WalletDetailCellIdentifier";

@interface WalletDetailCell : UITableViewCell

@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UIImageView *arrowImageView;

@end

NS_ASSUME_NONNULL_END
