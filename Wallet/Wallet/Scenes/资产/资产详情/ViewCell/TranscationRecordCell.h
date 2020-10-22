//
//  TranscationRecordCell.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/19.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TranscationRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *transferType;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end

NS_ASSUME_NONNULL_END
