//
//  ResetTradePwdScene.h
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/14.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "BaseViewController.h"
#import "LocalWallet.h"
NS_ASSUME_NONNULL_BEGIN

@interface ResetTradePwdScene : BaseViewController
@property (nonatomic,strong) LocalWallet *model;
@property (nonatomic,strong)void(^resetBlock)(NSString *);
@end

NS_ASSUME_NONNULL_END
