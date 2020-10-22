//
//  UserManager.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()


@end

@implementation UserManager
+ (UserManager *)sharedInstance {
    static dispatch_once_t once;
    static UserManager * __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } );
    return __singleton__;
}

- (UserManager *)sharedInstance {
    return [UserManager sharedInstance];
}

+(void)setDefaultWalletWithWallet:(LocalWallet *)currentWallet{
    [UserManager sharedInstance].wallet = currentWallet;
    [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
    NSArray *currentList = [LocalWallet findByCriteria:[NSString stringWithFormat:@" WHERE account = '%@' ",currentWallet.account]];
    if(currentList.count>0){
        [currentWallet update];
    }else{
        [currentWallet save];
    }
    NSArray *wallets = [LocalWallet findAll];
    for(int i = 0; i < wallets.count; i++){
        LocalWallet *wallet = wallets[i];
        if([currentWallet.account isEqualToString:wallet.account]){
            wallet.isdefault = @"1";
        }else{
            wallet.isdefault = @"";
        }
    }
    [LocalWallet updateObjects:wallets];
}

@end
