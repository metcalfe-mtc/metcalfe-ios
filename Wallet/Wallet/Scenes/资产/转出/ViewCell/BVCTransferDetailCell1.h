//
//  BVCTransferDetailCell1.h
//  BVCPay
//
//  Created by 钱伟成 on 2019/1/18.
//  Copyright © 2019年 智能流量链联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BVCTransferDetailCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *cPbutton;
@property (nonatomic,strong) void (^cpBlock)(NSInteger);

- (IBAction)cpButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
