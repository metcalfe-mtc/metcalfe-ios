//
//  RequestManager.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/2.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "RequestManager.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NSString+AES.h"
#import "UIDevice+COD.h"



@interface RequestManager ()

@property (strong, nonatomic) AFHTTPSessionManager * httpSessionManager;
@property (nonatomic,strong) NSString *languageType;
@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation RequestManager

DEF_SINGLETON(RequestManager)


- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)logWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    //#ifdef DEBUG
    NSLog(@"\n<--\n%@\n%@\n%@\n-->\n", task.currentRequest.URL, task.taskDescription, responseObject);
    //#endif
}

- (void)logWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    //#ifdef DEBUG
    NSLog(@"\n<--\n%@\n%@\n%@\n-->\n", task.currentRequest.URL, task.taskDescription, error);
    //#endif
}

//获取版本信息
+(void)getVersionWithProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    RequestManager *manager = [RequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/custom/basic/get_version"];
    NSMutableDictionary  *parameter = [NSMutableDictionary dictionary];
    parameter[@"code"] = APPV_CODE;
    parameter[@"type"] = @"ios";
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"success"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

//资产列表(获取基础币种余额)
+(void)getAssetsBaseValueWithProgress:(BOOL)showProgress account:(NSString *)account ledgerInddex:(NSString *)ledgerIndex withFee:(BOOL)withFee success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    RequestManager *manager = [RequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/core/account/info"];
    NSMutableDictionary  *parameter = [NSMutableDictionary dictionary];
    parameter[@"account"] = account;
    parameter[@"ledgerIndex"] = ledgerIndex;
    parameter[@"withFee"] = @"true";
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"success"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

+(void)getAssetsSecValueWithProgress:(BOOL)showProgress account:(NSString *)account ledgerInddex:(NSString *)ledgerIndex limit:(NSNumber *)limit marker:(NSString *)marker success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    RequestManager *manager = [RequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/core/account/lines"];
    NSMutableDictionary  *parameter = [NSMutableDictionary dictionary];
    parameter[@"account"] = account;
    parameter[@"ledgerIndex"] = ledgerIndex;
    parameter[@"limit"] = limit;
    if(marker){
        parameter[@"marker"] = marker;
    }
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"success"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

//转账记录
+(void)getTranscationRecordsWithProgress:(BOOL)showProgress account:(NSString *)account forward:(BOOL)forward ledgerIndexMax:(NSNumber *)ledgerIndexMax ledgerIndexMin:(NSNumber *)ledgerIndexMin limit:(NSNumber *)limit marker:(NSString *)marker success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    RequestManager *manager = [RequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/core/transaction/account"];
    NSMutableDictionary  *parameter = [NSMutableDictionary dictionary];
    parameter[@"account"] = account;
    parameter[@"forward"] = @"false";
    parameter[@"ledgerIndexMax"] = ledgerIndexMax;
    parameter[@"ledgerIndexMin"] = ledgerIndexMin;
    parameter[@"limit"] = limit;
    if(marker){
        parameter[@"marker"] = marker;
    }
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"success"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

//获取授信列表token
+(void)getCreditTokenListWithProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    RequestManager *manager = [RequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/custom/token/list"];
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"success"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

//授信
+(void)trustSetWithCurrency:(NSString *)currency fee:(NSString *)fee issuer:(NSString *)issuer sequence:(NSString *)sequence value:(NSString *)value progress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;{
    RequestManager *manager = [RequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/core/prepare/trustSet"];
    NSMutableDictionary  *parameter = [NSMutableDictionary dictionary];
    parameter[@"account"] = [UserManager sharedInstance].wallet.account;
    parameter[@"fee"] = fee;
    parameter[@"issuer"] = issuer;
    parameter[@"sequence"] = sequence;
    parameter[@"value"] = value;
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"success"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

//转账
+(void)getTranscationAccountWithProgress:(BOOL)showProgress success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    RequestManager *manager = [RequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/core/transaction/account"];
    NSMutableDictionary  *parameter = [NSMutableDictionary dictionary];
    parameter[@"account"] = [UserManager sharedInstance].wallet.account;
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"success"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

//交易详情
+(void)getTranscationDetailWithProgress:(BOOL)showProgress hash:(NSString *)hash success:(void(^)(NSURLSessionDataTask * task, id responseObject))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure{
    RequestManager *manager = [RequestManager sharedInstance];
    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/core/transaction/tx"];
    NSMutableDictionary  *parameter = [NSMutableDictionary dictionary];
    parameter[@"hash"] = hash;
    if(showProgress){
        [manager showProgressHUD];
    }
    [manager.httpSessionManager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task responseObject:responseObject];
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([statusStr isEqualToString:@"success"]){
            if(success){
                success(task,responseObject[@"data"]);
            }
        }
        else{
            if(warn){
                warn(responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showProgress) {
            [manager hideProgressHUD];
        }
        [manager logWithTask:task error:error];
        if (failure) {
            failure(task, error);
        }
    }];
}

//交易提交
+(void)transcationSubmitWithProgress:(BOOL)showProgress hash:(NSString *)hash txBlob:(NSString *)txBlob success:(void(^)(id result))success warn:(void(^)(NSString * content))warn error:(void(^)(NSString * content))error failure:(void(^)(NSError * error))failure{
    
    
    NSDictionary *body = @{@"hash":hash,
                           @"txBlob":txBlob
                           };
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[BASE_URL_NORMAL stringByAppendingString:@"api/core/transaction/submit"] parameters:nil error:nil];
    
    req.timeoutInterval= 20;
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
                if(success){
                    success(responseObject);
                }
            }
            
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if (failure) {
                failure(error);
            }
            
        }
        
    }] resume];
    
    
    
    
    
    
    
    
    
    
    
//    RequestManager *manager = [RequestManager sharedInstance];
//    NSString *urlStr = [BASE_URL_NORMAL stringByAppendingString:@"api/core/transaction/submit"];
//    NSMutableDictionary  *parameter = [NSMutableDictionary dictionary];
//    parameter[@"hash"] = hash;
//    parameter[@"txBlob"] = txBlob;
//    if(showProgress){
//        [manager showProgressHUD];
//    }
//    [manager.httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.httpSessionManager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (showProgress) {
//            [manager hideProgressHUD];
//        }
//        [manager logWithTask:task responseObject:responseObject];
//        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        if([statusStr isEqualToString:@"success"]){
//            if(success){
//                success(task,responseObject[@"data"]);
//            }
//        }
//        else{
//            if(warn){
//                warn(responseObject[@"message"]);
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (showProgress) {
//            [manager hideProgressHUD];
//        }
//        [manager logWithTask:task error:error];
//        if (failure) {
//            failure(task, error);
//        }
//    }];
}



#pragma mark - getter

- (AFHTTPSessionManager *)httpSessionManager {
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        _httpSessionManager.requestSerializer.timeoutInterval = 30;
        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"text/javascript", @"application/javascript",@"application/x-www-form-urlencoded;charset=UTF-8", nil];
        //无条件的信任服务器上的证书
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        _httpSessionManager.securityPolicy = securityPolicy;
    }
    //    [_httpSessionManager.requestSerializer setValue:[UIDevice currentDevice].name forHTTPHeaderField:@"devicename"];
    //    [_httpSessionManager.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"mobilesystem"];
    return _httpSessionManager;
}


@end
