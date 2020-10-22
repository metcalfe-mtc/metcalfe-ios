//
//  TradePasswordView.h
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/20.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradePasswordView : UIView
@property(nonatomic,copy)void (^inputCompleteBlock)(NSString *);
@property(nonatomic,copy)void (^cancleInputBlock)(void);
-(instancetype)initWithFrame:(CGRect)frame secretkey:(NSString *)secretkey;
-(void)showPaymentSecretInputView;

-(void)hidePaymentSecretInputView;
@end

NS_ASSUME_NONNULL_END
