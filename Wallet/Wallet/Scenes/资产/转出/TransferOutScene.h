//
//  TransferOutScene.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/18.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BaseViewController.h"
#import "BalanceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TransferOutScene : BaseViewController

@property(nonatomic,strong) BalanceModel *balance;
@property(nonatomic,strong) NSString *availableValue;

@end

NS_ASSUME_NONNULL_END
