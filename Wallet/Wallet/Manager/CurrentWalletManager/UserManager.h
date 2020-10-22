//
//  UserManager.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalWallet.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject
@property(nonatomic,strong) LocalWallet *wallet;

+(void)setDefaultWalletWithWallet:(LocalWallet *)currentWallet;

+ (UserManager *)sharedInstance;

- (UserManager *)sharedInstance;
@end

NS_ASSUME_NONNULL_END
