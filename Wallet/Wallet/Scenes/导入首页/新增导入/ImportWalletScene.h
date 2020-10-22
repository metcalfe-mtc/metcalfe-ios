//
//  ImportWalletScene.h
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/7.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ImportWalletScene : BaseViewController

@property(nonatomic,copy) void (^secretImportSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
