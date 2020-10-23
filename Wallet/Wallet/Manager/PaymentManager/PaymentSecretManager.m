//
//  PaymentSecretManager.m
//  HuiTongTingChe
//
//  Created by 钱伟成 on 2017/11/2.
//  Copyright © 2017年 HuiTong. All rights reserved.
//

#import "PaymentSecretManager.h"
#import "BaseNavigationController.h"
#import "TradePasswordView.h"
#import "TranscationConfirmView.h"

@implementation PaymentSecretManager

+ (PaymentSecretManager *)shareInstance {
    static dispatch_once_t once;
    static PaymentSecretManager * __singleton__;
    dispatch_once(&once, ^{
        __singleton__ = [[self alloc] init];
    });
    return __singleton__;
}

- (PaymentSecretManager *)shareInstance {
    return [[self class] shareInstance];
}

-(void)presentSecretSceneWithSecretkey:(NSString *)secretkey{
        TradePasswordView *secretView = [[TradePasswordView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) secretkey:secretkey];
    __weak PaymentSecretManager *weakSelf = self;
    
    __weak TradePasswordView *weakView = secretView ;
    
    secretView.inputCompleteBlock = ^(NSString *passWord) {
                [weakView hidePaymentSecretInputView];
                if(weakSelf.PaymemtSecretCurrectBlock){
                    weakSelf.PaymemtSecretCurrectBlock(passWord);
                }
    };
    secretView.cancleInputBlock = ^{
        if(weakSelf.PaymemtSecretCancleBlock){
            weakSelf.PaymemtSecretCancleBlock();
        }
    };
    [secretView showPaymentSecretInputView];
}

- (void)presentSecretSceneWithSecretkey:(NSString *)secretkey amount:(NSString *)amount currency:(NSString *)currency inc:(NSString *)inc type:(NSString *)type{
    TranscationConfirmView *secretView = [[TranscationConfirmView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) amount:amount currency:currency inc:inc type:type];
    __weak PaymentSecretManager *weakSelf = self;
    
    __weak TranscationConfirmView *weakView = secretView ;
    
    secretView.inputCompleteBlock = ^(NSString *passWord) {
        
        if (weakSelf.candismiss) {
            [weakView hidePaymentSecretInputView];
            
        }
        if(weakSelf.PaymemtSecretCurrectBlock){
            weakSelf.PaymemtSecretCurrectBlock(passWord);
        }
    };
    [secretView showPaymentSecretInputView];
}


- (void)dismissSecretScene {
    [[UIApplication sharedApplication].delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
