//
//  WalletModel.m
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/18.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel
+(JSONKeyMapper*)keyMapper
{
    JSONKeyMapper *baseMapper = [[JSONKeyMapper alloc] initWithModelToJSONBlock:^NSString *(NSString *keyName){
        return keyName;
    }];
    return [JSONKeyMapper baseMapper:baseMapper
           withModelToJSONExceptions:@{
                                       }];
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    
    return true;
}
+(BOOL)propertyIsIgnored:(NSString *)propertyName
{
    
    return NO;
}
+(NSString*)protocolForArrayProperty:(NSString *)propertyName
{
    
    return nil;
}
@end
