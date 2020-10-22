//
//  CreditModel.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/20.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreditModel : NSObject

@property(nonatomic,strong)NSString *currency;
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic,strong)NSString *issuer;
@property(nonatomic,strong)NSString *value;
@property(nonatomic,strong)NSString *credited;

-(void)setupTokenWithDict:(NSDictionary *)dict;
-(void)setupWithIssuer:(NSString *)issuer currency:(NSString *)currency value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
