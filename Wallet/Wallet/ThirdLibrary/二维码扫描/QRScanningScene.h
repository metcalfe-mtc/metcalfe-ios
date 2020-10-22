//
//  QRScanningScene.h
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/18.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRScanningScene : BaseViewController
@property (nonatomic,copy)void(^blockQRResult)(NSString *result);
@end

NS_ASSUME_NONNULL_END
