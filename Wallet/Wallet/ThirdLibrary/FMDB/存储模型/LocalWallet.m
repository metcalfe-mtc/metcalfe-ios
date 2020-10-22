//
//  LocalWallet.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/13.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "LocalWallet.h"

@implementation LocalWallet

-(void)configureWithAccount:(NSString *)account name:(NSString *)name secret:(NSString *)secret{
    self.account = account;
    self.name = name;
    self.secret = secret;
}

@end
