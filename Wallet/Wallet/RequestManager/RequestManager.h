//
//  RequestManager.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/2.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EzSingleton.h"
NS_ASSUME_NONNULL_BEGIN

@interface RequestManager : NSObject

AS_SINGLETON(RequestManager)

- (void)showProgressHUD;
- (void)hideProgressHUD;

//获取版本信息
+(void)getVersionWithProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//资产列表(获取基础币种余额
+(void)getAssetsBaseValueWithProgress:(BOOL)showProgress account:(NSString *)account ledgerInddex:(NSString *)ledgerIndex withFee:(BOOL)withFee success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//资产列表(获取二级资产币种余额)
+(void)getAssetsSecValueWithProgress:(BOOL)showProgress account:(NSString *)account ledgerInddex:(NSString *)ledgerIndex limit:(NSNumber *)limit marker:(NSString *)marker success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//转账记录
+(void)getTranscationRecordsWithProgress:(BOOL)showProgress account:(NSString *)account forward:(BOOL)forward ledgerIndexMax:(NSNumber *)ledgerIndexMax ledgerIndexMin:(NSNumber *)ledgerIndexMin limit:(NSNumber *)limit marker:(NSString *)marker success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//获取授信列表token
+(void)getCreditTokenListWithProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//授信
+(void)trustSetWithCurrency:(NSString *)currency fee:(NSString *)fee issuer:(NSString *)issuer sequence:(NSString *)sequence value:(NSString *)value progress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

//交易提交
+(void)transcationSubmitWithProgress:(BOOL)showProgress hash:(NSString *)hash txBlob:(NSString *)txBlob success:(void(^)(id result))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSError * error))failure;

//交易详情
+(void)getTranscationDetailWithProgress:(BOOL)showProgress hash:(NSString *)hash success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
