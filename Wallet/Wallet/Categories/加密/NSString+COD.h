//
//  NSString+COD.h
//  CutOrder
//
//  Created by yhw on 14-10-13.
//  Copyright (c) 2014年 YuQian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (COD)

- (NSString *)cod_md5;
+ (NSString *)cod_getMD5WithData:(NSData *)data;

- (NSString *)cod_urlEncoded;
- (NSString *)cod_urlDecoded;

- (BOOL)cod_isChinaMobile;// 手机
- (BOOL)cod_isEmail;// 邮箱
- (BOOL)cod_isVerificationCode;// 验证码
- (BOOL)cod_isChinaBankCard;// 银行卡

- (NSInteger)cod_wordCount;




/**
 *  将字符串转换成可用于URL中的字符串，主要是将一些特殊字符进行转换
 *
 *  @return 转换之后的字符串
 */
- (NSString *)escapeURIComponent;

/**
 *  获取当前字符串的MD5值
 *
 *  @return 字符串的MD5值
 */
- (NSString *)MD5Encode;

@end
