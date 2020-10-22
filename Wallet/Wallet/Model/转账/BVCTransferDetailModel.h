//
//  BVCTransferDetailModel.h
//  BVCPay
//
//  Created by 钱伟成 on 2019/1/21.
//  Copyright © 2019年 智能流量链联盟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BVCTransferDetailModel : NSObject

@property(nonatomic,strong) NSString *transferAccount;
@property(nonatomic,strong) NSString *receiverAccount;
@property(nonatomic,strong) NSString *amount;
@property(nonatomic,strong) NSString *fee;
@property(nonatomic,strong) NSString *transferType;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *transferHash;
@property(nonatomic,strong) NSString *block;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) NSString *memo;
@property(nonatomic,strong) NSString *currency;
@property(nonatomic,assign) BOOL validated;

-(void)initWithDict:(NSDictionary *)dict;

+(BVCTransferDetailModel *)modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
