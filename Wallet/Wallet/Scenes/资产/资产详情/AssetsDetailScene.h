//
//  AssetsDetailScene.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BaseViewController.h"
#import "BalanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsDetailScene : BaseViewController
@property(nonatomic,strong) BalanceModel *balance;
@property(nonatomic,strong) NSString *freezeStr;
@end

NS_ASSUME_NONNULL_END
