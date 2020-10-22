//
//  BaseViewController.h
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/15.
//  Copyright © 2018年 HengWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,strong)NSString * _Nonnull secret;
@property (nonatomic,strong)NSString * _Nonnull masterKey;
@property (nonatomic,strong)id _Nullable txJSON;
@property (nonatomic,strong)NSString * _Nullable validAddress;
@property (nonatomic,copy)void(^ _Nonnull generateAddress)(id _Nullable responseObject);
@property (nonatomic,copy)void(^ _Nullable generateMasterKeyWithSecret)(id _Nullable responseObject);
@property (nonatomic,copy)void(^ _Nullable generateSecretWithMasterKey)(id _Nullable responseObject);
@property (nonatomic,copy)void(^ _Nullable generateAddressWithSecret)(id _Nullable responseObject);
@property (nonatomic,copy)void(^ _Nullable signWithTxjsonAndSecret)(id _Nullable responseObject);
@property (nonatomic ,copy)void(^ _Nullable isValidAddress)(BOOL isValid);

- (void)setTitleViewWithWhiteTitle:(NSString * _Nonnull)title;
- (void)setTitleViewWithBlackTitle:(NSString * _Nonnull)title;

- (void)showString:(NSString *_Nullable)str delay:(NSTimeInterval)time;
- (void)showProgressHUDWithString:(NSString *_Nullable)str;
- (void)showProgressChangeHUDWithString:(NSString *_Nullable)str;
- (void)hideProgressHUDString;

- (void)generateAddressAction;
- (void)generateMasterKeyWithSecretAction:(NSString *_Nullable)secret;
- (void)generateSecretWithMasterKeyAction:(NSString *_Nullable)masterKey;
- (void)generateAddressWithSecretAction:(NSString *_Nullable)secret;
- (void)signActionWithTxjson:(id _Nullable )txJSON withSecret:(NSString *_Nullable)secret;
- (void)validAddress:(NSString *_Nullable)address;

@end
