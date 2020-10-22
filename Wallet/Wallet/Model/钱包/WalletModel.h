//
//  WalletModel.h
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/18.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletModel : JSONModel
@property(nonatomic,strong)NSString *account;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *userAccountId;

@property(nonatomic,strong)NSString *isdefault;

@property(nonatomic,strong)NSString *status;

@property(nonatomic,strong)NSString *secret;

@end

NS_ASSUME_NONNULL_END
