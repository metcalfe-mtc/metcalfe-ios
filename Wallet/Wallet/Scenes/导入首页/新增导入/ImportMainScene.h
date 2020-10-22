//
//  ImportMainScene.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/6.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImportMainScene : BaseViewController

@property(nonatomic,copy) void (^importWalletSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
