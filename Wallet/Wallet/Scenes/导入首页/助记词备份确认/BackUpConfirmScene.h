//
//  BackUpConfirmScene.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/5.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BaseViewController.h"
#import "LocalWallet.h"
NS_ASSUME_NONNULL_BEGIN

@interface BackUpConfirmScene : BaseViewController
@property(nonatomic,strong) LocalWallet *wallet;
@property(nonatomic,strong) NSArray *words;
@end

NS_ASSUME_NONNULL_END
