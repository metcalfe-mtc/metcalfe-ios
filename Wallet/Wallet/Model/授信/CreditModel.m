//
//  CreditModel.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/20.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "CreditModel.h"

@implementation CreditModel

-(void)setupTokenWithDict:(NSDictionary *)dict{
    self.currency = dict[@"currency"];
    self.imgUrl = dict[@"imgUrl"];
    self.issuer = dict[@"issuer"];
    self.value = dict[@"value"];
}

-(void)setupWithIssuer:(NSString *)issuer currency:(NSString *)currency value:(NSString *)value{
    self.currency = currency;
    self.issuer = issuer;
    self.value = value;
}

@end
