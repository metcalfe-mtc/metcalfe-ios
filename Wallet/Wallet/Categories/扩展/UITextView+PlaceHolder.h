//
//  UITextView+PlaceHolder.h
//  Wallet
//
//  Created by 钱伟成 on 2019/9/29.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UITextView (PlaceHolder)
-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;
@end

NS_ASSUME_NONNULL_END
