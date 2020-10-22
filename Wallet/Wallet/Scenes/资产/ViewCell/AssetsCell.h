//
//  AssetsCell.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/3.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currency;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@end

NS_ASSUME_NONNULL_END
