//
//  WordsBriefScene.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/9.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BaseViewController.h"
#import "LocalWallet.h"
NS_ASSUME_NONNULL_BEGIN

@interface WordsBriefScene : BaseViewController
@property(nonatomic,strong) NSString *uselessStr;
@property(nonatomic,strong) LocalWallet *wallet;
@end

NS_ASSUME_NONNULL_END
