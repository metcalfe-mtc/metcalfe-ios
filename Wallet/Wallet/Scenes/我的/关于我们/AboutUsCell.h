//
//  AboutUsCell.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/14.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutUsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

NS_ASSUME_NONNULL_END
