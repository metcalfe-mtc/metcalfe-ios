//
//  NSString+format.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/19.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "NSString+format.h"

@implementation NSString (format)
+ (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    return text;
}
@end
