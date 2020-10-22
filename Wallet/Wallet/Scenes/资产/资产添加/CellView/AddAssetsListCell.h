//
//  AddAssetsListCell.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/14.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddAssetsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *currency;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (nonatomic,assign) BOOL trustStatus;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property(nonatomic,strong) void (^trusted)(BOOL,NSInteger);

- (IBAction)switchButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
