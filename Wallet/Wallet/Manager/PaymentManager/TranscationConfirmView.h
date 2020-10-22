//
//  TranscationConfirmView.h
//  BVCPay
//
//  Created by 钱伟成 on 2019/9/16.
//  Copyright © 2019 MTC联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TranscationConfirmView : UIView
@property(nonatomic,copy)void (^inputCompleteBlock)(NSString *);
@property(nonatomic,copy)void (^forgetBlock)(void);
-(instancetype)initWithFrame:(CGRect)frame amount:(NSString *)amount currency:(NSString *)currency inc:(NSString *)inc type:(NSString *)type;
-(void)showPaymentSecretInputView;
-(void)hidePaymentSecretInputView;
@end

NS_ASSUME_NONNULL_END
