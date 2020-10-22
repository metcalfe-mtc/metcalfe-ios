//
//  BVCTransferDetailModel.m
//  BVCPay
//
//  Created by 钱伟成 on 2019/1/21.
//  Copyright © 2019年 智能流量链联盟. All rights reserved.
//

#import "BVCTransferDetailModel.h"
#import "NSString+TEDecimalNumber.h"
@implementation BVCTransferDetailModel

-(void)initWithDict:(NSDictionary *)dict{
    self.transferAccount = dict[@"account"];
    self.receiverAccount = dict[@"destination"];
    if(dict[@"amount"] &&![dict[@"amount"] isKindOfClass:[NSNull class]]){
        if(!dict[@"amount"][@"currency"]){
            self.amount = dict[@"amount"][@"value"];
            self.amount = [self.amount calculateByDividing:@"1000000"];
            self.currency = DEFAULTCURRENCY;
        }else{
            self.amount = dict[@"amount"][@"value"];
            self.currency = dict[@"amount"][@"currency"];
        }
        
        
    }
    self.fee = [NSString stringWithFormat:@"%@ %@",[dict[@"fee"] calculateByDividing:@"1000000"],DEFAULTCURRENCY];
    self.status = dict[@"transactionResult"];
    self.validated = dict[@"validated"];
    self.transferType = dict[@"transactionType"];
    if(self.validated){
        if([dict[@"transactionResult"] isEqualToString:@"tesSUCCESS"]){
            self.status = GetStringWithKeyFromTable(@"成功_status", LOCALIZABE, nil);
        }else{
            self.status = GetStringWithKeyFromTable(@"失败_status", LOCALIZABE, nil);
        }
        self.time = [NSObject timeWithSecondStr:dict[@"date"] withFormatStyle:@"yyyy-MM-dd HH:mm"];
        self.block = dict[@"ledgerIndex"];
    }else{
        self.time = @"";
        self.block = @"";
    }
    self.transferHash = dict[@"hash"];
    

    if(dict[@"memos"]&& ![dict[@"memos"] isKindOfClass:[NSNull class]]){
        
        self.memo = dict[@"memos"][0][@"memoDataText"];
    }else{
        self.memo = @"";
    }
}

+(BVCTransferDetailModel *)modelWithDict:(NSDictionary *)dict{
    BVCTransferDetailModel *model = [[BVCTransferDetailModel alloc] init];
    [model initWithDict:dict];
    return model;
}

@end
