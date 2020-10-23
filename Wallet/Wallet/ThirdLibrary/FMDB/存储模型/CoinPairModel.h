//
//  CoinPairModel.h
//  BVCPay
//
//  Created by 钱伟成 on 2018/11/21.
//  Copyright © 2018年 MTC联盟. All rights reserved.
//

#import "JKDBModel.h"

@interface CoinPairModel : JKDBModel

@property(nonatomic,strong)NSString *currencyPair;
@property(nonatomic,strong)NSString *currency2;
@property(nonatomic,strong)NSString *counterparty2;
@property(nonatomic,strong)NSString *currency0;
@property(nonatomic,strong)NSString *counterparty0;
@property(nonatomic,strong)NSString *limit2;
@property(nonatomic,strong)NSString *limit0;
@property(nonatomic,strong)NSString *pic2;
@property(nonatomic,strong)NSString *pic0;

-(CoinPairModel *)configureWithCurrency2:(NSString *)currency2 counterparty2:(NSString *)counterparty2 currency0:(NSString *)currency0 counterparty0:(NSString *)counterparty0 limit2:(NSString *)limit2 limit0:(NSString *)limit0 pic2:(NSString *)pic2 pic0:(NSString *)pic0;

@end
