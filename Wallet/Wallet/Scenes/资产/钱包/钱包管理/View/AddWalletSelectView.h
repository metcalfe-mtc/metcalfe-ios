//
//  AddWalletSelectView.h
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/7.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddWalletSelectView : UIView
@property(nonatomic,copy)void (^createWalletBlock)(NSString *);
@property(nonatomic,copy)void (^leadInWalletBlock)(NSString *);

-(instancetype)initWithFrame:(CGRect)frame;
-(void)showAddWalletSelectView;
-(void)hideAddWalletSelectView;
@end

NS_ASSUME_NONNULL_END
