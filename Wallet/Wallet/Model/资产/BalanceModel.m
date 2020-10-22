//
//  BalanceModel.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BalanceModel.h"
#import "NSString+TEDecimalNumber.h"

@implementation BalanceModel
-(void)modelWithAccount:(NSString *)account currency:(NSString *)currency balance:(NSString *)balance baseFee:(NSString *)baseFee ledgerIndex:(NSString *)ledgerIndex sequence:(NSString *)sequence{
    self.account = account;
    self.currency = currency;
    self.balance = balance;
    if([self.currency isEqualToString:DEFAULTCURRENCY]){
        self.balance = [balance calculateByDividing:@"1000000"];
    }
    self.baseFee = baseFee;
    self.ledgerIndex = self.ledgerIndex;
    self.sequence = sequence;
}
@end
