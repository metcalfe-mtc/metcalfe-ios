//
//  WordBackUpScene.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/9.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BaseViewController.h"
#import "LocalWallet.h"
NS_ASSUME_NONNULL_BEGIN

@interface WordBackUpScene : BaseViewController
@property(nonatomic,strong) LocalWallet *wallet;
@property(nonatomic,strong) NSString *words;
@property(nonatomic,strong) NSString *type;
@end

NS_ASSUME_NONNULL_END
