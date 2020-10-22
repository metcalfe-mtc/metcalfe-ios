//
//  CoinPairModel.m
//  BVCPay
//
//  Created by 钱伟成 on 2018/11/21.
//  Copyright © 2018年 MTC联盟. All rights reserved.
//

#import "CoinPairModel.h"

@implementation CoinPairModel

-(CoinPairModel *)configureWithCurrency2:(NSString *)currency2 counterparty2:(NSString *)counterparty2 currency0:(NSString *)currency0 counterparty0:(NSString *)counterparty0 limit2:(NSString *)limit2 limit0:(NSString *)limit0 pic2:(NSString *)pic2 pic0:(NSString *)pic0{
    self.currencyPair = [NSString stringWithFormat:@"%@/%@",currency0,currency2];
    self.currency2 = currency2;
        self.counterparty2 = counterparty2;
        self.currency0 = currency0;
        self.counterparty0 = counterparty0;
        self.limit2 = limit2;
        self.limit0 = limit0;
        self.pic2 = pic2;
        self.pic0 = pic0;
    return self;
}

@end
