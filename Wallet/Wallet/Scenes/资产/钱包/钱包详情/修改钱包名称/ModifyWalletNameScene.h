//
//  ModifyWalletNameScene.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BaseViewController.h"
#import "LocalWallet.h"
NS_ASSUME_NONNULL_BEGIN

@interface ModifyWalletNameScene : BaseViewController
@property(nonatomic,strong) LocalWallet *wallet;
@property(nonatomic,copy) void(^modifyNameBlock)(LocalWallet *);
@end

NS_ASSUME_NONNULL_END
