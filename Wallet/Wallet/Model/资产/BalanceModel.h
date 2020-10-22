//
//  BalanceModel.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BalanceModel : NSObject
@property(nonatomic,strong) NSString *account;
@property(nonatomic,strong) NSString *currency;
@property(nonatomic,strong) NSString *balance;
@property(nonatomic,strong) NSString *baseFee;
@property(nonatomic,strong) NSString *freeze;
@property(nonatomic,strong) NSString *ledgerIndex;
@property(nonatomic,strong) NSString *sequence;
-(void)modelWithAccount:(NSString *)account currency:(NSString *)currency balance:(NSString *)balance baseFee:(NSString *)baseFee ledgerIndex:(NSString *)ledgerIndex sequence:(NSString *)sequence;

@end

NS_ASSUME_NONNULL_END
