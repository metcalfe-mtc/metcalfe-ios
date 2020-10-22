//
//  LocalWallet.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/13.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "JKDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalWallet : JKDBModel
@property(nonatomic,strong)NSString *account;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *isdefault;

@property(nonatomic,strong)NSString *secret;

-(void)configureWithAccount:(NSString *)account name:(NSString *)name secret:(NSString *)secret;

@end

NS_ASSUME_NONNULL_END
