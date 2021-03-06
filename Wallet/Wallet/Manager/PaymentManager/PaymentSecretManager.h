//
//  PaymentSecretManager.h
//  HuiTongTingChe
//
//  Created by 钱伟成 on 2017/11/2.
//  Copyright © 2017年 HuiTong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PaymentSccretManagerDelegate;

@interface PaymentSecretManager : NSObject

@property(nonatomic,copy)void (^PaymemtSecretUnsetBlock)(void);

@property(nonatomic,copy)void (^PaymemtSecretCurrectBlock)(NSString *);

@property(nonatomic,copy)void (^PaymemtSecretErrorBlock)(void);

@property(nonatomic,copy)void (^PaymemtSecretCancleBlock)(void);

@property(nonatomic,copy)void (^PaymentDismissBlock)(void);

@property (nonatomic,assign)BOOL candismiss;

+(PaymentSecretManager *)shareInstance;
-(PaymentSecretManager *)shareInstance;

- (void)presentSecretSceneWithSecretkey:(NSString *)secretkey;
- (void)presentSecretSceneWithSecretkey:(NSString *)secretkey amount:(NSString *)amount currency:(NSString *)currency inc:(NSString *)inc type:(NSString *)type;
- (void)dismissSecretScene;

@end


@protocol PaymentSccretManagerDelegate <NSObject>

-(void)secretManager:(PaymentSecretManager *)manager paymentSuccessWithResponse:(id)response;

-(void)secretManager:(PaymentSecretManager *)manager content:(NSString *)content;

-(void)secretManager:(PaymentSecretManager *)manager loginFalure:(NSError *)falure;

@end
