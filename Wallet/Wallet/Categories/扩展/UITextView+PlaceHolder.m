//
//  UITextView+PlaceHolder.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/29.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "UITextView+PlaceHolder.h"

@implementation UITextView (PlaceHolder)
-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor
{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeholdStr;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = placeholdColor;
    placeHolderLabel.font = self.font;
    [placeHolderLabel sizeToFit];
    UILabel *placeholder = [self valueForKey:@"_placeholderLabel"];
    //防止重复
    if (placeholder) {
        return;
    }
    [self addSubview:placeHolderLabel];
    [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

@end
