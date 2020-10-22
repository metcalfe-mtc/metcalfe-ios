//
//  WalletListScene.h
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/11.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "BaseViewController.h"
#import "LocalWallet.h"
NS_ASSUME_NONNULL_BEGIN

@interface WalletListScene : BaseViewController

@property(nonatomic,copy) void (^walletSelectBlock)(LocalWallet *);

@end

NS_ASSUME_NONNULL_END
